import 'package:fitness/features/ai_agent/data/datasource/knowledge_local_datasource.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:injectable/injectable.dart';

/// Result of an explicit, unambiguous request that can be answered from the
/// local database alone, skipping the round trip to Ollama Cloud.
class FastPathResult {
  const FastPathResult({
    required this.type,
    required this.items,
    required this.refs,
  });

  final AiRefType type;
  final List<Map<String, Object?>> items;
  final List<AiRefEntity> refs;
}

/// Dart port of the old Node `fastPath` service.
@lazySingleton
class FastPathRecognizer {
  const FastPathRecognizer(this._knowledge);

  final KnowledgeLocalDatasource _knowledge;

  static final RegExp _exerciseIntent = RegExp(
    r'تمارين|تمرين|عضلات|عضلة|exercise|workout',
    caseSensitive: false,
  );
  static final RegExp _mealIntent = RegExp(
    r'وجبة|وجبات|أكل|اكل|طعام|meal|diet|recipe',
    caseSensitive: false,
  );
  static final RegExp _exerciseNoise = RegExp(
    r'تمارين|تمرين|workout|exercise',
    caseSensitive: false,
  );
  static final RegExp _mealNoise = RegExp(
    r'وجبة|وجبات|meal|recipes?',
    caseSensitive: false,
  );

  static const Map<String, String> _muscleGroups = {
    r'باي|بايسبس|biceps': 'biceps',
    r'تراي|ترايسبس|triceps': 'triceps',
    r'صدر|chest': 'chest',
    r'ظهر|back': 'back',
    r'أكتاف|اكتاف|كتف|shoulders?': 'shoulders',
    r'أرجل|ارجل|رجل|legs|quads': 'legs',
    r'بطن|abs|core': 'abs',
  };

  static const Map<String, String> _equipment = {
    r'دمبل|دمبلز|dumbbell': 'dumbbell',
    r'بار|barbell': 'barbell',
    r'كيبل|cable': 'cable',
  };

  Future<FastPathResult?> detectAndExecute(String userMessage) async {
    final message = userMessage.trim();
    if (message.isEmpty) return null;

    if (_exerciseIntent.hasMatch(message)) {
      final exercises = await _knowledge.searchExercises(
        muscleGroup: _firstMatch(_muscleGroups, message),
        equipment: _firstMatch(_equipment, message),
        query: message.replaceAll(_exerciseNoise, '').trim(),
      );

      if (exercises.isNotEmpty) {
        return FastPathResult(
          type: AiRefType.exercise,
          items: exercises,
          refs: exercises
              .map(
                (row) =>
                    KnowledgeSearchResult.refFromRow(row, AiRefType.exercise),
              )
              .toList(),
        );
      }
    }

    if (_mealIntent.hasMatch(message)) {
      final wantsProtein = RegExp(
        r'بروتين|protein',
        caseSensitive: false,
      ).hasMatch(message);

      final meals = await _knowledge.searchMeals(
        minProteinG: wantsProtein ? 20 : null,
        query: message.replaceAll(_mealNoise, '').trim(),
      );

      if (meals.isNotEmpty) {
        return FastPathResult(
          type: AiRefType.meal,
          items: meals,
          refs: meals
              .map(
                (row) => KnowledgeSearchResult.refFromRow(row, AiRefType.meal),
              )
              .toList(),
        );
      }
    }

    return null;
  }

  static String? _firstMatch(Map<String, String> patterns, String message) {
    for (final entry in patterns.entries) {
      if (RegExp(entry.key, caseSensitive: false).hasMatch(message)) {
        return entry.value;
      }
    }
    return null;
  }
}
