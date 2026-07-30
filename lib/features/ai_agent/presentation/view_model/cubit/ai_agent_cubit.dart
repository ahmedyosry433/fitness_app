import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_agent_stream_event.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/delete_conversation_use_case.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/get_conversation_messages_use_case.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/get_conversations_use_case.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/save_chat_message_use_case.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/send_agent_message_use_case.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/start_conversation_use_case.dart';
import 'package:fitness/features/ai_agent/domain/use_cases/update_chat_message_use_case.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_intent.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_navigation.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class AiAgentCubit
    extends BaseCubit<BaseState<AiAgentUIModel>, AiAgentNavigation> {
  AiAgentCubit(
    this.sendAgentMessageUseCase,
    this.getConversationsUseCase,
    this.getConversationMessagesUseCase,
    this.startConversationUseCase,
    this.saveChatMessageUseCase,
    this.updateChatMessageUseCase,
    this.deleteConversationUseCase,
  ) : super(const BaseState.initial());

  final SendAgentMessageUseCase sendAgentMessageUseCase;
  final GetConversationsUseCase getConversationsUseCase;
  final GetConversationMessagesUseCase getConversationMessagesUseCase;
  final StartConversationUseCase startConversationUseCase;
  final SaveChatMessageUseCase saveChatMessageUseCase;
  final UpdateChatMessageUseCase updateChatMessageUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;

  StreamSubscription<AiAgentStreamEvent>? _answerSubscription;
  int? _streamingMessageId;

  AiAgentUIModel get _data => state.data ?? const AiAgentUIModel();

  static ChatMessageEntity get greeting => ChatMessageEntity(
    text: LocaleKeys.ai_agent_greeting.tr(),
    isUser: false,
  );

  @override
  Future<void> doAction(AiAgentIntent event) async {
    switch (event) {
      case LoadConversationsIntent():
        await _loadConversations();
      case OpenConversationIntent(:final conversationId):
        await _openConversation(conversationId);
      case StartNewConversationIntent():
        _startNewConversation();
      case SendMessageIntent(:final text):
        await _sendMessage(text);
      case AttachImageIntent(:final imagePath):
        _emit(_data.copyWith(pendingImagePath: imagePath));
      case ClearImageAttachmentIntent():
        _emit(_data.copyWith(clearPendingImage: true));
      case DeleteConversationIntent(:final conversationId):
        await _deleteConversation(conversationId);
    }
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await getConversationsUseCase();
      _emit(_data.copyWith(conversations: conversations));
    } on Exception catch (exception) {
      _emitError(exception);
    }
  }

  Future<void> _openConversation(int? conversationId) async {
    if (conversationId == null) {
      _startNewConversation();
      await _loadConversations();
      return;
    }

    _emit(_data, stateType: StateType.loading);
    try {
      final messages = await getConversationMessagesUseCase(conversationId);
      final conversations = await getConversationsUseCase();
      _emit(
        _data.copyWith(
          conversationId: conversationId,
          conversations: conversations,
          messages: [greeting, ...messages],
        ),
      );
      doNavigationAction(const ScrollToBottomNavigation());
    } on Exception catch (exception) {
      _emitError(exception);
    }
  }

  void _startNewConversation() {
    _answerSubscription?.cancel();
    _answerSubscription = null;
    _streamingMessageId = null;
    _emit(
      _data.copyWith(
        clearConversationId: true,
        clearPendingImage: true,
        messages: [greeting],
        isStreaming: false,
      ),
    );
  }

  Future<void> _sendMessage(String rawText) async {
    final text = rawText.trim();
    final imagePath = _data.pendingImagePath;
    final hasImage = _data.hasPendingImage;

    // Loading guard: one answer at a time. An image alone is a valid message.
    if ((text.isEmpty && !hasImage) || _data.isStreaming) return;

    _emit(
      _data.copyWith(
        isStreaming: true,
        clearPendingImage: true,
        messages: [
          ..._data.messages,
          ChatMessageEntity(text: text, isUser: true, imagePath: imagePath),
          const ChatMessageEntity(text: '', isUser: false),
        ],
      ),
    );
    doNavigationAction(const ScrollToBottomNavigation());

    final title = text.isNotEmpty
        ? text
        : LocaleKeys.ai_agent_analyze_image.tr();
    final conversationId =
        _data.conversationId ?? await startConversationUseCase(title);

    await saveChatMessageUseCase(
      conversationId: conversationId,
      text: text,
      isUser: true,
      imagePath: imagePath,
    );
    _streamingMessageId = await saveChatMessageUseCase(
      conversationId: conversationId,
      text: '',
      isUser: false,
    );

    final conversations = await getConversationsUseCase();
    _emit(
      _data.copyWith(
        conversationId: conversationId,
        conversations: conversations,
      ),
    );

    // The empty placeholder must not be sent to the model, but an image-only
    // message must survive the filter.
    final history = _data.messages
        .where((message) => message.text.trim().isNotEmpty || message.hasImage)
        .toList();

    await _answerSubscription?.cancel();
    _answerSubscription = sendAgentMessageUseCase(history).listen(
      _onStreamEvent,
      onDone: _finishAnswer,
      onError: (Object error) {
        _updateAnswer(
          (current) => current.copyWith(
            text: current.text.isEmpty
                ? LocaleKeys.ai_agent_unexpected_error.tr()
                : current.text,
          ),
        );
        _finishAnswer();
      },
      cancelOnError: true,
    );
  }

  void _onStreamEvent(AiAgentStreamEvent event) {
    switch (event.type) {
      case AiAgentStreamEventType.token:
        _updateAnswer(
          (current) =>
              current.copyWith(text: current.text + (event.content ?? '')),
        );
      case AiAgentStreamEventType.refs:
        _updateAnswer(
          (current) =>
              current.copyWith(refs: _mergeRefs(current.refs, event.refs)),
        );
      case AiAgentStreamEventType.error:
        _updateAnswer(
          (current) => current.copyWith(
            text: current.text.isEmpty
                ? (event.content ?? LocaleKeys.ai_agent_unexpected_error.tr())
                : '${current.text}\n\n[${event.content}]',
          ),
        );
      case AiAgentStreamEventType.done:
        break;
    }
    doNavigationAction(const ScrollToBottomNavigation());
  }

  /// Rewrites the trailing assistant message that is being streamed.
  void _updateAnswer(
    ChatMessageEntity Function(ChatMessageEntity current) transform,
  ) {
    final messages = [..._data.messages];
    if (messages.isEmpty) return;

    final lastIndex = messages.length - 1;
    if (messages[lastIndex].isUser) return;

    messages[lastIndex] = transform(messages[lastIndex]);
    _emit(_data.copyWith(messages: messages));
  }

  Future<void> _finishAnswer() async {
    final messageId = _streamingMessageId;
    _streamingMessageId = null;

    final answer = _data.messages.isEmpty ? null : _data.messages.last;
    _emit(_data.copyWith(isStreaming: false));

    if (messageId == null || answer == null || answer.isUser) return;

    await updateChatMessageUseCase(
      messageId: messageId,
      text: answer.text,
      refs: answer.refs,
    );
  }

  Future<void> _deleteConversation(int conversationId) async {
    await deleteConversationUseCase(conversationId);
    if (_data.conversationId == conversationId) {
      _startNewConversation();
    }
    await _loadConversations();
  }

  void _emit(AiAgentUIModel data, {StateType stateType = StateType.success}) {
    emit(BaseState.all(state: stateType, data: data, exception: null));
  }

  void _emitError(Exception exception) {
    emit(
      BaseState.all(
        state: StateType.error,
        data: _data,
        exception: exception,
      ),
    );
  }

  static List<AiRefEntity> _mergeRefs(
    List<AiRefEntity> current,
    List<AiRefEntity> incoming,
  ) {
    final seen = <String>{
      for (final ref in current) '${ref.type.name}:${ref.id}',
    };
    return [
      ...current,
      ...incoming.where((ref) => seen.add('${ref.type.name}:${ref.id}')),
    ];
  }

  @override
  Future<void> close() {
    _answerSubscription?.cancel();
    return super.close();
  }
}
