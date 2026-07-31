import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/api/ollama_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/ai_agent/data/datasource/knowledge_local_datasource.dart';
import 'package:fitness/features/ai_agent/data/datasource/ollama_remote_datasource.dart';
import 'package:fitness/features/ai_agent/data/tools/ai_tool_registry.dart';
import 'package:fitness/features/ai_agent/data/tools/fast_path_recognizer.dart';
import 'package:fitness/features/ai_agent/data/tools/image_attachment_encoder.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_agent_stream_event.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_user_context_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ollama_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Orchestrates one assistant turn entirely from the app:
/// fast path -> Ollama Cloud tool turn -> local tool execution -> streamed answer,
/// with a local-only degraded mode whenever the cloud call fails.
@LazySingleton(as: OllamaRepository)
class OllamaRepositoryImpl implements OllamaRepository {
  const OllamaRepositoryImpl(
    this._remote,
    this._knowledge,
    this._tools,
    this._fastPath,
    this._imageEncoder,
  );

  final OllamaRemoteDatasource _remote;
  final KnowledgeLocalDatasource _knowledge;
  final AiToolRegistry _tools;
  final FastPathRecognizer _fastPath;
  final ImageAttachmentEncoder _imageEncoder;

  String get _groundedFallback => LocaleKeys.ai_agent_grounded_fallback.tr();
  String get _emptyAnswerFallback => LocaleKeys.ai_agent_empty_answer.tr();
  String get _degradedWithResults =>
      '${LocaleKeys.ai_agent_degraded_with_results.tr()}\n';
  String get _degradedWithoutResults =>
      LocaleKeys.ai_agent_degraded_without_results.tr();
  String get _missingKey => LocaleKeys.ai_agent_missing_api_key.tr();
  String get _imageUnreadable => LocaleKeys.ai_agent_image_unreadable.tr();
  String get _defaultImagePrompt => LocaleKeys.ai_agent_analyze_image.tr();
  String get _imageRecommendations =>
      LocaleKeys.ai_agent_image_recommendations.tr();
  String get _serviceBusy => LocaleKeys.ai_agent_service_busy.tr();

  @override
  Stream<AiAgentStreamEvent> sendMessage(
    List<ChatMessageEntity> conversation, {
    AiUserContextEntity userContext = AiUserContextEntity.empty,
  }) async* {
    final lastUserTurn = _lastUserTurn(conversation);
    final userMessage = lastUserTurn?.text.trim() ?? '';

    // Step 0 - an attached photo takes the multimodal path.
    if (lastUserTurn != null && lastUserTurn.hasImage) {
      yield* _analyzeImage(conversation, lastUserTurn, userContext);
      return;
    }

    if (userMessage.isEmpty) {
      yield const AiAgentStreamEvent.done();
      return;
    }

    // Step 1 - explicit request answerable from local data only.
    final fastPath = await _fastPath.detectAndExecute(userMessage);
    if (fastPath != null) {
      yield AiAgentStreamEvent.refs(fastPath.refs);
      yield AiAgentStreamEvent.token(_formatFastPath(fastPath));
      yield const AiAgentStreamEvent.done();
      return;
    }

    // Step 2 - Ollama Cloud with locally executed tools.
    try {
      if (!OllamaConfig.isConfigured) {
        throw const OllamaException('OLLAMA_API_KEY is not configured');
      }

      final baseMessages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': await _tools.buildSystemPrompt(userContext: userContext),
        },
        ...conversation.map((message) => message.toChatTurn()),
      ];

      final toolTurn = await _remote.chat(
        messages: baseMessages,
        tools: _tools.toolDefinitions,
      );

      if (!toolTurn.hasToolCalls) {
        yield AiAgentStreamEvent.token(
          toolTurn.content.isEmpty ? _emptyAnswerFallback : toolTurn.content,
        );
        yield const AiAgentStreamEvent.done();
        return;
      }

      final refs = <AiRefEntity>[];
      final toolMessages = <Map<String, dynamic>>[];

      for (final call in toolTurn.toolCalls) {
        final outcome = await _tools.execute(call);
        refs.addAll(outcome.refs);
        toolMessages.add({
          'role': 'tool',
          'tool_name': outcome.toolName,
          'content': outcome.encodeForModel(),
        });
      }

      final groundedRefs = _dedupeRefs(refs);
      if (groundedRefs.isNotEmpty) {
        yield AiAgentStreamEvent.refs(groundedRefs);
      }

      var streamedAnything = false;
      final answerStream = _remote.streamChat(
        messages: [
          ...baseMessages,
          {
            'role': 'assistant',
            'content': toolTurn.content,
            'tool_calls': toolTurn.toolCalls,
          },
          ...toolMessages,
        ],
      );

      await for (final token in answerStream) {
        streamedAnything = true;
        yield AiAgentStreamEvent.token(token);
      }

      if (!streamedAnything) {
        yield AiAgentStreamEvent.token(
          toolTurn.content.isEmpty ? _groundedFallback : toolTurn.content,
        );
      }

      yield const AiAgentStreamEvent.done();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[AiAgent] degraded mode: $error');
      }
      yield* _degradedMode(userMessage, error);
    }
  }

  /// Sends the attached photo to the vision model, streams the analysis, then
  /// grounds it with real exercise/meal rows from the local database.
  Stream<AiAgentStreamEvent> _analyzeImage(
    List<ChatMessageEntity> conversation,
    ChatMessageEntity imageTurn,
    AiUserContextEntity userContext,
  ) async* {
    final encodedImage = await _imageEncoder.encodeToBase64(
      imageTurn.imagePath,
    );

    if (encodedImage == null) {
      yield AiAgentStreamEvent.token(_imageUnreadable);
      yield const AiAgentStreamEvent.done();
      return;
    }

    final caption = imageTurn.text.trim().isEmpty
        ? _defaultImagePrompt
        : imageTurn.text.trim();

    try {
      if (!OllamaConfig.isConfigured) {
        throw const OllamaException('OLLAMA_API_KEY is not configured');
      }

      final history = conversation
          .where((message) => message != imageTurn && !message.hasImage)
          .map((message) => message.toChatTurn())
          .toList();

      final visionMessages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': await _tools.buildVisionPrompt(userContext: userContext),
        },
        ...history,
        {
          'role': 'user',
          'content': caption,
          'images': [encodedImage],
        },
      ];

      final analysis = StringBuffer();
      OllamaException? lastFailure;

      // Ollama Cloud drops vision requests with a 5xx from time to time, and
      // not every model on the plan accepts images, so fall back model by model.
      for (final visionModel in OllamaConfig.visionModels) {
        try {
          final visionStream = _remote.streamChat(
            model: visionModel,
            messages: visionMessages,
          );

          await for (final token in visionStream) {
            analysis.write(token);
            yield AiAgentStreamEvent.token(token);
          }

          if (analysis.isNotEmpty) break;
        } on OllamaException catch (error) {
          lastFailure = error;
          if (kDebugMode) {
            debugPrint('[AiAgent] vision model $visionModel failed: $error');
          }
          // Part of the answer is already on screen: do not restart it.
          if (analysis.isNotEmpty) break;
        }
      }

      if (analysis.isEmpty) {
        yield AiAgentStreamEvent.token(
          lastFailure != null && !lastFailure.isModelUnavailable
              ? _serviceBusy
              : _imageUnreadable,
        );
        yield const AiAgentStreamEvent.done();
        return;
      }

      final refs = await _refsFromAnalysis(caption, analysis.toString());
      if (refs.isNotEmpty) {
        yield AiAgentStreamEvent.token('\n\n$_imageRecommendations');
        yield AiAgentStreamEvent.refs(refs);
      }

      yield const AiAgentStreamEvent.done();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[AiAgent] image analysis failed: $error');
      }
      yield* _degradedMode(caption, error);
    }
  }

  /// Turns a free-text image analysis into grounded refs: the text model picks
  /// the tool arguments, and the tools only ever return real database rows.
  Future<List<AiRefEntity>> _refsFromAnalysis(
    String caption,
    String analysis,
  ) async {
    try {
      final grounding = await _remote.chat(
        messages: [
          {'role': 'system', 'content': await _tools.buildSystemPrompt()},
          {
            'role': 'user',
            'content':
                '$caption\n\n[Image analysis]\n$analysis\n\n'
                'Use the available tools to suggest real exercises or meals '
                'that match this analysis.',
          },
        ],
        tools: _tools.toolDefinitions,
      );

      final refs = <AiRefEntity>[];
      for (final call in grounding.toolCalls) {
        refs.addAll((await _tools.execute(call)).refs);
      }
      if (refs.isNotEmpty) return _dedupeRefs(refs);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[AiAgent] grounding failed: $error');
      }
    }

    final local = await _knowledge.searchByText(analysis);
    return _dedupeRefs(local.toRefs());
  }

  /// Local-only answer used when Ollama Cloud is unreachable, unauthorized or
  /// rate limited.
  Stream<AiAgentStreamEvent> _degradedMode(
    String userMessage,
    Object error,
  ) async* {
    final results = await _knowledge.searchByText(userMessage);
    final refs = _dedupeRefs(results.toRefs());

    if (refs.isNotEmpty) {
      yield AiAgentStreamEvent.refs(refs);
      yield AiAgentStreamEvent.token(_degradedWithResults);
    } else if (error is OllamaException && !OllamaConfig.isConfigured) {
      yield AiAgentStreamEvent.token(_missingKey);
    } else {
      yield AiAgentStreamEvent.token(_degradedWithoutResults);
    }

    yield const AiAgentStreamEvent.done();
  }

  String _formatFastPath(FastPathResult fastPath) {
    final buffer = StringBuffer();

    if (fastPath.type == AiRefType.exercise) {
      buffer.writeln(LocaleKeys.ai_agent_exercises_intro.tr());
      buffer.writeln();
      for (final row in fastPath.items) {
        final name = KnowledgeSearchResult.localizedName(row) ?? '';
        final equipment =
            row['equipment_name'] ?? LocaleKeys.ai_agent_no_equipment.tr();
        buffer.writeln('• **$name** ($equipment)');
      }
    } else {
      final calories = LocaleKeys.ai_agent_calories.tr();
      final proteinLabel = LocaleKeys.ai_agent_protein.tr();
      buffer.writeln(LocaleKeys.ai_agent_meals_intro.tr());
      buffer.writeln();
      for (final row in fastPath.items) {
        final name = KnowledgeSearchResult.localizedName(row) ?? '';
        final kcal = _formatNumber(row['kcal']);
        final protein = _formatNumber(row['protein_g']);
        buffer.writeln(
          '• **$name** - $kcal $calories ($protein g $proteinLabel)',
        );
      }
    }

    return buffer.toString();
  }

  static String _formatNumber(Object? value) {
    if (value is num) {
      return value == value.roundToDouble()
          ? value.round().toString()
          : value.toStringAsFixed(1);
    }
    return '—';
  }

  static ChatMessageEntity? _lastUserTurn(
    List<ChatMessageEntity> conversation,
  ) {
    for (final message in conversation.reversed) {
      if (!message.isUser) continue;
      if (message.text.trim().isNotEmpty || message.hasImage) return message;
    }
    return null;
  }

  static List<AiRefEntity> _dedupeRefs(List<AiRefEntity> refs) {
    final seen = <String>{};
    return refs.where((ref) => seen.add('${ref.type.name}:${ref.id}')).toList();
  }
}
