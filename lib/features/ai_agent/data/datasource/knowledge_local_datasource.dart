import 'package:drift/drift.dart';
import 'package:fitness/features/ai_agent/data/local/knowledge_database.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:injectable/injectable.dart';

/// Dart port of the old Node `dbCompiler`: every filter, the relaxation ladder
/// and the full-text fallbacks now run on-device against the bundled sqlite
/// databases. This is what the model's tool calls are executed against.
@lazySingleton
class KnowledgeLocalDatasource {
  KnowledgeLocalDatasource(this._databases);

  final KnowledgeDatabases _databases;

  Map<String, List<Map<String, Object?>>>? _vocabularyCache;

  static const int _defaultLimit = 10;
  static const int _textSearchLimit = 5;

  KnowledgeDatabase get _exercisesDb => _databases.exercises;
  KnowledgeDatabase get _mealsDb => _databases.meals;

  /// Lookup values injected into the system prompt so the model uses real
  /// category ids instead of guessing them.
  Future<Map<String, List<Map<String, Object?>>>> getVocabulary() async {
    if (_vocabularyCache != null) return _vocabularyCache!;

    final vocabulary = <String, List<Map<String, Object?>>>{};
    try {
      vocabulary['muscle_groups'] = await _exercisesDb.rawQuery(
        'SELECT id, name, name_ar FROM muscle_group ORDER BY name',
      );
      vocabulary['muscles'] = await _exercisesDb.rawQuery(
        'SELECT id, name, name_ar FROM muscle ORDER BY name LIMIT 30',
      );
      vocabulary['equipment'] = await _exercisesDb.rawQuery(
        'SELECT id, name, name_ar FROM equipment ORDER BY name',
      );
      vocabulary['difficulty'] = await _exercisesDb.rawQuery(
        'SELECT id, name, name_ar FROM difficulty_level ORDER BY rank',
      );
      vocabulary['meal_categories'] = await _mealsDb.rawQuery(
        'SELECT id, name, name_ar FROM meal_category ORDER BY name',
      );
      vocabulary['meal_areas'] = await _mealsDb.rawQuery(
        'SELECT id, name, name_ar FROM meal_area ORDER BY name',
      );
    } catch (_) {
      // A partially readable database still gives a usable prompt.
    }

    _vocabularyCache = vocabulary;
    return vocabulary;
  }

  /// Relaxation ladder: narrow first, then progressively drop constraints so the
  /// user always gets grounded results instead of an empty answer.
  Future<List<Map<String, Object?>>> searchExercises({
    String? muscleGroup,
    String? primeMover,
    String? equipment,
    String? difficulty,
    String? query,
  }) async {
    var results = await _queryExercises(
      muscleGroup: muscleGroup,
      primeMover: primeMover,
      equipment: equipment,
      difficulty: difficulty,
      query: query,
    );
    if (results.isNotEmpty) return results;

    if (equipment != null) {
      results = await _queryExercises(
        muscleGroup: muscleGroup,
        primeMover: primeMover,
        difficulty: difficulty,
        query: query,
      );
      if (results.isNotEmpty) return results;
    }

    if (difficulty != null) {
      results = await _queryExercises(
        muscleGroup: muscleGroup,
        primeMover: primeMover,
        query: query,
      );
      if (results.isNotEmpty) return results;
    }

    if (query != null && query.trim().isNotEmpty) {
      results = await searchExercisesByText(query);
      if (results.isNotEmpty) return results;
    }

    if (muscleGroup != null) {
      return _queryExercises(muscleGroup: muscleGroup, limit: 5);
    }

    return const [];
  }

  Future<List<Map<String, Object?>>> searchMeals({
    String? category,
    String? area,
    num? maxKcal,
    num? minProteinG,
    String? query,
  }) async {
    var results = await _queryMeals(
      category: category,
      area: area,
      maxKcal: maxKcal,
      minProteinG: minProteinG,
      query: query,
    );
    if (results.isNotEmpty) return results;

    if (area != null) {
      results = await _queryMeals(
        category: category,
        maxKcal: maxKcal,
        minProteinG: minProteinG,
        query: query,
      );
      if (results.isNotEmpty) return results;
    }

    if (maxKcal != null || minProteinG != null) {
      results = await _queryMeals(category: category, query: query);
      if (results.isNotEmpty) return results;
    }

    if (query != null && query.trim().isNotEmpty) {
      results = await searchMealsByText(query);
      if (results.isNotEmpty) return results;
    }

    return const [];
  }

  /// Cross-database text search used by the generic tool and by degraded mode.
  Future<KnowledgeSearchResult> searchByText(String text) async {
    final exercises = await searchExercisesByText(text);
    final meals = await searchMealsByText(text);
    return KnowledgeSearchResult(exercises: exercises, meals: meals);
  }

  Future<List<Map<String, Object?>>> searchExercisesByText(String text) async {
    final ftsQuery = _buildFtsQuery(text);
    if (ftsQuery != null) {
      final matches = await _safeQuery(
        _exercisesDb,
        '''
        SELECT e.id, e.name, e.name_ar, e.posture, e.demo_url, e.popularity,
               mg.name AS muscle_group_name, eq.name AS equipment_name
        FROM exercise_fts f
        JOIN exercise e ON e.id = f.id
        LEFT JOIN muscle_group mg ON mg.id = e.muscle_group_id
        LEFT JOIN equipment eq ON eq.id = e.primary_equipment_id
        WHERE exercise_fts MATCH ?
        ORDER BY e.popularity DESC
        LIMIT ?
        ''',
        [Variable<String>(ftsQuery), Variable<int>(_textSearchLimit)],
      );
      if (matches.isNotEmpty) return matches;
    }

    final pattern = _likePattern(text);
    if (pattern == null) return const [];

    return _safeQuery(
      _exercisesDb,
      '''
      SELECT e.id, e.name, e.name_ar, e.posture, e.demo_url, e.popularity,
             mg.name AS muscle_group_name, eq.name AS equipment_name
      FROM exercise e
      LEFT JOIN muscle_group mg ON mg.id = e.muscle_group_id
      LEFT JOIN equipment eq ON eq.id = e.primary_equipment_id
      WHERE e.name LIKE ? OR e.name_ar LIKE ?
      ORDER BY e.popularity DESC
      LIMIT ?
      ''',
      [
        Variable<String>(pattern),
        Variable<String>(pattern),
        Variable<int>(_textSearchLimit),
      ],
    );
  }

  Future<List<Map<String, Object?>>> searchMealsByText(String text) async {
    final ftsQuery = _buildFtsQuery(text);
    if (ftsQuery != null) {
      final matches = await _safeQuery(
        _mealsDb,
        '''
        SELECT m.id, m.name, m.name_ar, m.kcal, m.protein_g, m.carbs_g, m.fat_g,
               m.thumb, m.popularity, mc.name AS category_name
        FROM meal_fts f
        JOIN meal m ON m.id = f.id
        LEFT JOIN meal_category mc ON mc.id = m.category_id
        WHERE meal_fts MATCH ?
        ORDER BY m.popularity DESC
        LIMIT ?
        ''',
        [Variable<String>(ftsQuery), Variable<int>(_textSearchLimit)],
      );
      if (matches.isNotEmpty) return matches;
    }

    final pattern = _likePattern(text);
    if (pattern == null) return const [];

    return _safeQuery(
      _mealsDb,
      '''
      SELECT m.id, m.name, m.name_ar, m.kcal, m.protein_g, m.carbs_g, m.fat_g,
             m.thumb, m.popularity, mc.name AS category_name
      FROM meal m
      LEFT JOIN meal_category mc ON mc.id = m.category_id
      WHERE m.name LIKE ? OR m.name_ar LIKE ?
      ORDER BY m.popularity DESC
      LIMIT ?
      ''',
      [
        Variable<String>(pattern),
        Variable<String>(pattern),
        Variable<int>(_textSearchLimit),
      ],
    );
  }

  Future<List<Map<String, Object?>>> _queryExercises({
    String? muscleGroup,
    String? primeMover,
    String? equipment,
    String? difficulty,
    String? query,
    int limit = _defaultLimit,
  }) {
    final buffer = StringBuffer('''
      SELECT DISTINCT e.id, e.name, e.name_ar, e.posture, e.demo_url, e.popularity,
             mg.name AS muscle_group_name, eq.name AS equipment_name,
             dl.name AS difficulty_name
      FROM exercise e
      LEFT JOIN muscle_group mg ON mg.id = e.muscle_group_id
      LEFT JOIN equipment eq ON eq.id = e.primary_equipment_id
      LEFT JOIN difficulty_level dl ON dl.id = e.difficulty_id
      WHERE 1 = 1
    ''');
    final variables = <Variable<Object>>[];

    void addFilter(String clause, List<String> patterns) {
      buffer.writeln(clause);
      variables.addAll(patterns.map(Variable<String>.new));
    }

    if (_hasValue(muscleGroup)) {
      final pattern = '%${muscleGroup!.trim()}%';
      addFilter(' AND (mg.id LIKE ? OR mg.name LIKE ? OR mg.name_ar LIKE ?)', [
        pattern,
        pattern,
        pattern,
      ]);
    }

    if (_hasValue(primeMover)) {
      final pattern = '%${primeMover!.trim()}%';
      addFilter(
        ' AND (e.prime_mover_id LIKE ? OR e.name LIKE ? OR e.name_ar LIKE ?)',
        [pattern, pattern, pattern],
      );
    }

    if (_hasValue(equipment)) {
      final pattern = '%${equipment!.trim()}%';
      addFilter(' AND (eq.id LIKE ? OR eq.name LIKE ? OR eq.name_ar LIKE ?)', [
        pattern,
        pattern,
        pattern,
      ]);
    }

    if (_hasValue(difficulty)) {
      final pattern = '%${difficulty!.trim()}%';
      addFilter(' AND (dl.id LIKE ? OR dl.name LIKE ? OR dl.name_ar LIKE ?)', [
        pattern,
        pattern,
        pattern,
      ]);
    }

    if (_hasValue(query)) {
      final pattern = '%${query!.trim()}%';
      addFilter(' AND (e.name LIKE ? OR e.name_ar LIKE ?)', [pattern, pattern]);
    }

    buffer.writeln(' ORDER BY e.popularity DESC LIMIT ?');
    variables.add(Variable<int>(limit));

    return _safeQuery(_exercisesDb, buffer.toString(), variables);
  }

  Future<List<Map<String, Object?>>> _queryMeals({
    String? category,
    String? area,
    num? maxKcal,
    num? minProteinG,
    String? query,
    int limit = _defaultLimit,
  }) {
    final buffer = StringBuffer('''
      SELECT DISTINCT m.id, m.name, m.name_ar, m.kcal, m.protein_g, m.carbs_g,
             m.fat_g, m.thumb, m.popularity, mc.name AS category_name,
             ma.name AS area_name
      FROM meal m
      LEFT JOIN meal_category mc ON mc.id = m.category_id
      LEFT JOIN meal_area ma ON ma.id = m.area_id
      WHERE 1 = 1
    ''');
    final variables = <Variable<Object>>[];

    if (_hasValue(category)) {
      final pattern = '%${category!.trim()}%';
      buffer.writeln(
        ' AND (mc.id LIKE ? OR mc.name LIKE ? OR mc.name_ar LIKE ?)',
      );
      variables.addAll([
        Variable<String>(pattern),
        Variable<String>(pattern),
        Variable<String>(pattern),
      ]);
    }

    if (_hasValue(area)) {
      final pattern = '%${area!.trim()}%';
      buffer.writeln(
        ' AND (ma.id LIKE ? OR ma.name LIKE ? OR ma.name_ar LIKE ?)',
      );
      variables.addAll([
        Variable<String>(pattern),
        Variable<String>(pattern),
        Variable<String>(pattern),
      ]);
    }

    if (maxKcal != null) {
      buffer.writeln(' AND m.kcal IS NOT NULL AND m.kcal <= ?');
      variables.add(Variable<double>(maxKcal.toDouble()));
    }

    if (minProteinG != null) {
      buffer.writeln(' AND m.protein_g IS NOT NULL AND m.protein_g >= ?');
      variables.add(Variable<double>(minProteinG.toDouble()));
    }

    if (_hasValue(query)) {
      final pattern = '%${query!.trim()}%';
      buffer.writeln(' AND (m.name LIKE ? OR m.name_ar LIKE ?)');
      variables.addAll([Variable<String>(pattern), Variable<String>(pattern)]);
    }

    buffer.writeln(' ORDER BY m.popularity DESC LIMIT ?');
    variables.add(Variable<int>(limit));

    return _safeQuery(_mealsDb, buffer.toString(), variables);
  }

  Future<List<Map<String, Object?>>> _safeQuery(
    KnowledgeDatabase database,
    String sql,
    List<Variable<Object>> variables,
  ) async {
    try {
      return await database.rawQuery(sql, variables);
    } catch (_) {
      return const [];
    }
  }

  static bool _hasValue(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// Builds an fts5 prefix query, or null when there is nothing searchable.
  static String? _buildFtsQuery(String text) {
    final tokens = text
        .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
        .where((token) => token.length > 1)
        .take(6)
        .toList();
    if (tokens.isEmpty) return null;
    return tokens.map((token) => '"$token"*').join(' OR ');
  }

  static String? _likePattern(String text) {
    final cleaned = text.replaceAll(RegExp(r'''[%_'"\\]'''), ' ').trim();
    if (cleaned.isEmpty) return null;
    return '%$cleaned%';
  }
}

class KnowledgeSearchResult {
  const KnowledgeSearchResult({required this.exercises, required this.meals});

  final List<Map<String, Object?>> exercises;
  final List<Map<String, Object?>> meals;

  bool get isEmpty => exercises.isEmpty && meals.isEmpty;

  List<AiRefEntity> toRefs() => [
    ...exercises.map((row) => refFromRow(row, AiRefType.exercise)),
    ...meals.map((row) => refFromRow(row, AiRefType.meal)),
  ];

  static AiRefEntity refFromRow(Map<String, Object?> row, AiRefType type) {
    final id = (row['id'] as String?) ?? '';
    final nameAr = row['name_ar'] as String?;
    final name = row['name'] as String?;
    return AiRefEntity(
      type: type,
      id: id,
      name: (nameAr != null && nameAr.trim().isNotEmpty)
          ? nameAr
          : (name ?? id),
    );
  }
}
