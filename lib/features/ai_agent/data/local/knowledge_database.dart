import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:fitness/features/ai_agent/data/local/asset_db/asset_db_bytes.dart';
import 'package:fitness/features/ai_agent/data/local/asset_db/asset_db_seed.dart';
import 'package:injectable/injectable.dart';

part 'knowledge_database.g.dart';

/// Read-only drift access to the bundled `exercises.db` / `meals.db` files.
///
/// The schema is owned by the shipped asset (it even contains fts5 virtual
/// tables), so no drift tables are declared here: every query is raw SQL through
/// [customSelect]. This is the Dart replacement for the old Node `dbCompiler`.
@DriftDatabase(tables: [])
class KnowledgeDatabase extends _$KnowledgeDatabase {
  KnowledgeDatabase.exercises()
    : super(
        _openBundledDatabase(
          assetKey: exercisesAssetKey,
          databaseName: 'ai_agent_exercises',
          fileName: 'ai_agent_exercises.db',
        ),
      );

  KnowledgeDatabase.meals()
    : super(
        _openBundledDatabase(
          assetKey: mealsAssetKey,
          databaseName: 'ai_agent_meals',
          fileName: 'ai_agent_meals.db',
        ),
      );

  static const String exercisesAssetKey = 'assets/data/exercises.db';
  static const String mealsAssetKey = 'assets/data/meals.db';

  @override
  int get schemaVersion => 1;

  /// The asset owns the schema, so drift must never try to create or alter it.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {},
    onUpgrade: (_, _, _) async {},
  );

  /// Runs a raw query and returns plain maps, mirroring the old JS helpers.
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Variable<Object>> variables = const [],
  ]) async {
    final rows = await customSelect(sql, variables: variables).get();
    return rows.map((row) => row.data).toList();
  }
}

QueryExecutor _openBundledDatabase({
  required String assetKey,
  required String databaseName,
  required String fileName,
}) {
  return driftDatabase(
    name: databaseName,
    native: DriftNativeOptions(
      databasePath: () =>
          seedAssetDatabasePath(assetKey: assetKey, fileName: fileName),
    ),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      initializeDatabase: () => loadAssetDatabaseBytes(assetKey),
    ),
  );
}

/// Holds both read-only knowledge databases as a single injectable unit.
@lazySingleton
class KnowledgeDatabases {
  KnowledgeDatabases()
    : exercises = KnowledgeDatabase.exercises(),
      meals = KnowledgeDatabase.meals();

  final KnowledgeDatabase exercises;
  final KnowledgeDatabase meals;

  @disposeMethod
  Future<void> close() async {
    await exercises.close();
    await meals.close();
  }
}
