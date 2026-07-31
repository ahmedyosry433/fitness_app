import 'dart:convert';

import 'package:fitness/core/languages/app_locale.dart';
import 'package:fitness/features/ai_agent/data/datasource/knowledge_local_datasource.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_user_context_entity.dart';
import 'package:injectable/injectable.dart';

/// Outcome of running one model tool call against the local database.
class ToolCallOutcome {
  const ToolCallOutcome({
    required this.toolName,
    required this.items,
    required this.refs,
  });

  final String toolName;
  final List<Map<String, Object?>> items;
  final List<AiRefEntity> refs;

  /// Compact payload sent back to the model as the `tool` turn.
  String encodeForModel({int maxItems = 10}) =>
      jsonEncode(items.take(maxItems).toList());
}

/// Tool schema + prompt + local execution. Dart port of the old `ollamaService`.
@lazySingleton
class AiToolRegistry {
  const AiToolRegistry(this._knowledge);

  final KnowledgeLocalDatasource _knowledge;

  static const String searchExercisesTool = 'search_exercises';
  static const String searchMealsTool = 'search_meals';
  static const String searchByTextTool = 'search_by_text';

  /// Language the model must answer in, taken from the active app locale.
  String get _answerLanguage => AppLocale.answerLanguage;

  Future<String> buildSystemPrompt({
    AiUserContextEntity userContext = AiUserContextEntity.empty,
  }) async {
    final vocabulary = await _knowledge.getVocabulary();

    String block(String key) => jsonEncode(vocabulary[key] ?? const []);

    final buffer = StringBuffer('''
You are the "Smart Coach", a professional fitness and nutrition assistant inside the Fitness App.

Answer rules:
1. Always answer in $_answerLanguage, whatever language the user writes in, in an encouraging and professional tone.
2. When recommending exercises or meals, call the available tools so the ids come from the real database.
3. Never invent or guess ids that are not present in the tool results.
4. Never mention the database, the tools or any other technical detail in your answer.

Formatting rules (they matter for the app UI):
5. Keep the answer short: 120 words maximum.
6. Use short paragraphs (two lines maximum) separated by a blank line.
7. For lists use "- " only, 5 items maximum.
8. No markdown headings (### or ##), no tables, no horizontal rules (---).
9. If you need a short title, wrap it in ** ** on its own line.
10. Never write external links or video links, and never write ids inside the text: the app renders exercise and meal cards under your answer.

[Vocabulary block - the classification values used in the database]:
- Muscle groups: ${block('muscle_groups')}
- Equipment: ${block('equipment')}
- Difficulty levels: ${block('difficulty')}
- Meal categories: ${block('meal_categories')}
''');

    buffer.write(_userContextBlock(userContext));

    return buffer.toString();
  }

  /// Profile fields + recap of the previous conversation, rendered as prompt
  /// blocks. Returns an empty string when nothing is known about the user.
  String _userContextBlock(AiUserContextEntity context) {
    if (context.isEmpty) return '';

    final buffer = StringBuffer();

    if (context.hasProfile) {
      buffer.writeln();
      buffer.writeln('[Current user - use it to personalise your answers]:');
      if (context.name != null) buffer.writeln('- Name: ${context.name}');
      if (context.email != null) buffer.writeln('- Email: ${context.email}');
      if (context.phone != null) buffer.writeln('- Phone: ${context.phone}');
      buffer.writeln(
        '- Greet them by their first name in your first answer only, '
        'then carry on normally.',
      );
      buffer.writeln(
        '- Never repeat their email or phone number unless they ask for it.',
      );
    }

    if (context.hasPreviousChat) {
      buffer.writeln();
      buffer.writeln(
        '[Recap of the last conversation with this user - context only]:',
      );
      if (context.previousChatTitle != null) {
        buffer.writeln('- Topic: ${context.previousChatTitle}');
      }
      if (context.previousChatDate != null) {
        buffer.writeln('- Date: ${_formatDate(context.previousChatDate!)}');
      }
      for (final turn in context.previousChatTurns) {
        buffer.writeln('- ${turn.isUser ? 'User' : 'You'}: ${turn.text}');
      }
      buffer.writeln(
        '- Use this only for continuity. Do not treat it as the current '
        'question, and do not repeat or comment on it unless it relates to '
        'the current message.',
      );
    }

    return buffer.toString();
  }

  static String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// Prompt for the multimodal model when the user attaches a photo.
  ///
  /// The vision model has no tools, so it is asked to name what it sees using
  /// database vocabulary; those words are then used to fetch grounded refs.
  Future<String> buildVisionPrompt({
    AiUserContextEntity userContext = AiUserContextEntity.empty,
  }) async {
    final vocabulary = await _knowledge.getVocabulary();

    String names(String key) {
      final rows = vocabulary[key] ?? const [];
      return rows
          .map((row) => row['name'])
          .whereType<String>()
          .take(25)
          .join(', ');
    }

    return '''
You are the "Smart Coach", a fitness and nutrition expert. The user sent you a photo.

What to do:
1. Identify precisely what the photo shows: a meal/food, an exercise or a piece of gym equipment, or something else.
2. If it is a meal: list the visible ingredients, give a rough calorie and protein estimate, and say whether it suits muscle gain or weight loss.
3. If it is an exercise or equipment: name the exercise, the target muscles, the key form cues and the common mistakes.
4. Close with one short, practical recommendation.
5. Whenever you mention a muscle, a piece of equipment or a meal category, add the English term in parentheses so it can be matched against the database.
6. Answer in $_answerLanguage, in an encouraging and concise tone, without any technical detail.
7. Never give a medical diagnosis: advise seeing a specialist for any health complaint.

Formatting rules (they matter for the app UI):
8. Keep the answer short: 120 words maximum, paragraphs of at most two lines, a blank line between paragraphs.
9. For lists use "- " only, 5 items maximum.
10. No markdown headings (### or ##), no tables, no horizontal rules (---). If you need a short title, wrap it in ** ** on its own line.
11. Never write external links or video links, and never write ids inside the text.

Available database vocabulary:
- Muscle groups: ${names('muscle_groups')}
- Equipment: ${names('equipment')}
- Meal categories: ${names('meal_categories')}
${_userContextBlock(userContext)}''';
  }

  List<Map<String, dynamic>> get toolDefinitions => [
    {
      'type': 'function',
      'function': {
        'name': searchExercisesTool,
        'description':
            'Search the database for exercises by target muscle, equipment '
            'and difficulty level.',
        'parameters': {
          'type': 'object',
          'properties': {
            'muscle_group': {
              'type': 'string',
              'description': 'Muscle group name or id',
            },
            'prime_mover': {
              'type': 'string',
              'description': 'Primary mover muscle',
            },
            'equipment': {
              'type': 'string',
              'description': 'Equipment being used',
            },
            'difficulty': {'type': 'string', 'description': 'Difficulty level'},
            'query': {
              'type': 'string',
              'description': 'Additional search keywords',
            },
          },
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': searchMealsTool,
        'description':
            'Search the database for meals by category, protein or calories.',
        'parameters': {
          'type': 'object',
          'properties': {
            'category': {'type': 'string', 'description': 'Meal category'},
            'area': {'type': 'string', 'description': 'Cuisine or area'},
            'min_protein_g': {
              'type': 'number',
              'description': 'Minimum protein in grams',
            },
            'max_kcal': {'type': 'number', 'description': 'Maximum calories'},
            'query': {
              'type': 'string',
              'description': 'Additional search keywords',
            },
          },
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': searchByTextTool,
        'description': 'Free text search across exercises and meals.',
        'parameters': {
          'type': 'object',
          'properties': {
            'text': {'type': 'string', 'description': 'The query text'},
          },
          'required': ['text'],
        },
      },
    },
  ];

  Future<ToolCallOutcome> execute(Map<String, dynamic> toolCall) async {
    final function = (toolCall['function'] as Map?)?.cast<String, dynamic>();
    final name = function?['name'] as String? ?? '';
    final arguments = _decodeArguments(function?['arguments']);

    switch (name) {
      case searchExercisesTool:
        final items = await _knowledge.searchExercises(
          muscleGroup: _string(arguments['muscle_group']),
          primeMover: _string(arguments['prime_mover']),
          equipment: _string(arguments['equipment']),
          difficulty: _string(arguments['difficulty']),
          query: _string(arguments['query']),
        );
        return _outcome(name, items, AiRefType.exercise);

      case searchMealsTool:
        final items = await _knowledge.searchMeals(
          category: _string(arguments['category']),
          area: _string(arguments['area']),
          maxKcal: _number(arguments['max_kcal']),
          minProteinG: _number(arguments['min_protein_g']),
          query: _string(arguments['query']),
        );
        return _outcome(name, items, AiRefType.meal);

      case searchByTextTool:
        final result = await _knowledge.searchByText(
          _string(arguments['text']) ?? '',
        );
        return ToolCallOutcome(
          toolName: name,
          items: [...result.exercises, ...result.meals],
          refs: _validate(result.toRefs(), [
            ...result.exercises,
            ...result.meals,
          ]),
        );

      default:
        return ToolCallOutcome(toolName: name, items: const [], refs: const []);
    }
  }

  ToolCallOutcome _outcome(
    String name,
    List<Map<String, Object?>> items,
    AiRefType type,
  ) {
    final refs = items
        .map((row) => KnowledgeSearchResult.refFromRow(row, type))
        .toList();
    return ToolCallOutcome(
      toolName: name,
      items: items,
      refs: _validate(refs, items),
    );
  }

  /// Keeps only refs whose id really came back from the database.
  List<AiRefEntity> _validate(
    List<AiRefEntity> candidates,
    List<Map<String, Object?>> rows,
  ) {
    final validIds = rows.map((row) => row['id']).whereType<String>().toSet();
    return candidates
        .where((ref) => ref.id.isNotEmpty && validIds.contains(ref.id))
        .toList();
  }

  static Map<String, dynamic> _decodeArguments(Object? raw) {
    if (raw is Map) return raw.cast<String, dynamic>();
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) return decoded.cast<String, dynamic>();
      } catch (_) {
        return const {};
      }
    }
    return const {};
  }

  static String? _string(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static num? _number(Object? value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value.trim());
    return null;
  }
}
