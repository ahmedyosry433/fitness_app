import 'dart:convert';

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

  Future<String> buildSystemPrompt({
    AiUserContextEntity userContext = AiUserContextEntity.empty,
  }) async {
    final vocabulary = await _knowledge.getVocabulary();

    String block(String key) => jsonEncode(vocabulary[key] ?? const []);

    final buffer = StringBuffer('''
أنت "المدرب الذكي (Smart Coach)" - مساعد افتراضي احترافي ومخصص للياقة البدنية والتغذية داخل تطبيق Fitness App.

قواعد الاستجابة المطلوبة:
1. الإجابة بنفس لغة المستخدم (عربي أو إنجليزي)، بأسلوب مشجع واحترافي.
2. عند تقديم توصيات بالتمارين أو الوجبات، يجب استخدام الأدوات المتاحة لجلب المعرفات الصحيحة الحقيقية من قاعدة البيانات.
3. يُحظر تماماً اختراع أو هلوسة معرفات (IDs) غير موجودة بالنتائج.
4. لا تذكر تفاصيل تقنية عن قاعدة البيانات أو الأدوات في ردك.

قواعد التنسيق (مهمة جداً لواجهة التطبيق):
5. اجعل الرد قصيراً: 120 كلمة كحد أقصى.
6. اكتب فقرات قصيرة (سطرين كحد أقصى لكل فقرة)، وافصل بين كل فقرة وأخرى بسطر فارغ.
7. للقوائم استخدم شرطة "- " فقط، وبحد أقصى 5 عناصر.
8. لا تستخدم عناوين ماركداون (### أو ##)، ولا جداول، ولا خطوط فاصلة (---).
9. عند الحاجة لعنوان قصير اكتبه بين ** ** في سطر مستقل.
10. لا تكتب أي روابط خارجية أو روابط فيديو إطلاقاً، ولا تكتب معرفات (IDs) داخل النص: التطبيق يعرض بطاقات جاهزة للتمارين والوجبات أسفل ردك.

[Vocabulary Block - مفردات التصنيف في قاعدة البيانات]:
- مجموعات العضلات: ${block('muscle_groups')}
- معدات التمارين: ${block('equipment')}
- مستويات الصعوبة: ${block('difficulty')}
- تصنيفات الوجبات: ${block('meal_categories')}
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
      buffer.writeln('[بيانات المستخدم الحالي - استخدمها لتخصيص ردودك]:');
      if (context.name != null) buffer.writeln('- الاسم: ${context.name}');
      if (context.email != null) {
        buffer.writeln('- البريد الإلكتروني: ${context.email}');
      }
      if (context.phone != null) {
        buffer.writeln('- رقم الهاتف: ${context.phone}');
      }
      buffer.writeln('- ناده باسمه الأول في أول رد فقط، ثم تابع بشكل طبيعي.');
      buffer.writeln(
        '- لا تذكر بريده أو رقم هاتفه في ردك إلا إذا سأل عنهما صراحةً.',
      );
    }

    if (context.hasPreviousChat) {
      buffer.writeln();
      buffer.writeln(
        '[ملخص آخر محادثة سابقة مع نفس المستخدم - للاستئناس فقط]:',
      );
      if (context.previousChatTitle != null) {
        buffer.writeln('- الموضوع: ${context.previousChatTitle}');
      }
      if (context.previousChatDate != null) {
        buffer.writeln('- التاريخ: ${_formatDate(context.previousChatDate!)}');
      }
      for (final turn in context.previousChatTurns) {
        buffer.writeln('- ${turn.isUser ? 'المستخدم' : 'أنت'}: ${turn.text}');
      }
      buffer.writeln(
        '- استخدم هذا السياق للاستمرارية فقط، ولا تفترض أنه سؤال الآن، '
        'ولا تكرره أو تعلّق عليه إلا إذا كان مرتبطاً برسالة المستخدم الحالية.',
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
أنت "المدرب الذكي (Smart Coach)"، خبير لياقة وتغذية. المستخدم أرسل لك صورة.

المطلوب:
1. حدد بدقة ما في الصورة: هل هي وجبة/طعام، أم تمرين أو معدة رياضية، أم شيء آخر؟
2. إذا كانت وجبة: اذكر المكونات الظاهرة، وتقديراً تقريبياً للسعرات والبروتين، وهل تناسب أهداف بناء العضل أم خسارة الوزن.
3. إذا كانت تمرين أو معدة: اذكر اسم التمرين والعضلات المستهدفة وأهم ملاحظات الأداء الصحيح والأخطاء الشائعة.
4. أنهِ ردك بتوصية عملية قصيرة.
5. اكتب أسماء العضلات أو المعدات أو تصنيفات الوجبات بالإنجليزية بين قوسين عند ذكرها، لتسهيل ربطها بقاعدة البيانات.
6. الرد بالعربية، بأسلوب مشجع ومختصر، دون ذكر تفاصيل تقنية.
7. لا تقدم تشخيصاً طبياً، وانصح بمراجعة مختص عند وجود أي شكوى صحية.

قواعد التنسيق (مهمة جداً لواجهة التطبيق):
8. اجعل الرد قصيراً: 120 كلمة كحد أقصى، بفقرات لا تزيد عن سطرين، وسطر فارغ بين كل فقرة وأخرى.
9. للقوائم استخدم شرطة "- " فقط وبحد أقصى 5 عناصر.
10. لا تستخدم عناوين ماركداون (### أو ##) ولا جداول ولا خطوط فاصلة (---)، وإن أردت عنواناً قصيراً اكتبه بين ** ** في سطر مستقل.
11. لا تكتب أي روابط خارجية أو روابط فيديو إطلاقاً، ولا تكتب معرفات (IDs) داخل النص.

مفردات قاعدة البيانات المتاحة:
- مجموعات العضلات: ${names('muscle_groups')}
- المعدات: ${names('equipment')}
- تصنيفات الوجبات: ${names('meal_categories')}
${_userContextBlock(userContext)}''';
  }

  List<Map<String, dynamic>> get toolDefinitions => [
    {
      'type': 'function',
      'function': {
        'name': searchExercisesTool,
        'description':
            'البحث عن تمارين في قاعدة البيانات حسب العضلة المستهدفة والمعدات والمستوى.',
        'parameters': {
          'type': 'object',
          'properties': {
            'muscle_group': {
              'type': 'string',
              'description': 'اسم أو معرف المجموعة العضلية',
            },
            'prime_mover': {
              'type': 'string',
              'description': 'العضلة الأساسية المحركة',
            },
            'equipment': {'type': 'string', 'description': 'المعدات المستعملة'},
            'difficulty': {'type': 'string', 'description': 'مستوى الصعوبة'},
            'query': {'type': 'string', 'description': 'كلمات بحث إضافية'},
          },
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': searchMealsTool,
        'description':
            'البحث عن وجبات في قاعدة البيانات حسب التصنيف أو البروتين أو السعرات.',
        'parameters': {
          'type': 'object',
          'properties': {
            'category': {'type': 'string', 'description': 'تصنيف الوجبة'},
            'area': {'type': 'string', 'description': 'المطبخ أو المنطقة'},
            'min_protein_g': {
              'type': 'number',
              'description': 'الحد الأدنى للبروتين بالغرام',
            },
            'max_kcal': {
              'type': 'number',
              'description': 'الحد الأقصى للسعرات الحرارية',
            },
            'query': {'type': 'string', 'description': 'كلمات بحث إضافية'},
          },
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': searchByTextTool,
        'description': 'البحث النصي العام في التمارين والوجبات.',
        'parameters': {
          'type': 'object',
          'properties': {
            'text': {'type': 'string', 'description': 'نص الاستعلام'},
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
