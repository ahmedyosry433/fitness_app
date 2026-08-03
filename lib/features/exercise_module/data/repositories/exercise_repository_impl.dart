import 'package:fitness/config/api/api_executer.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/data/datasources/exercise_remote_data_source.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource _remoteDataSource;

  ExerciseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ExerciseEntity>>> getAllExercises(
      {required String primeMoverMuscleId, required String difficultyLevelId}) {
    return executeApi(() async {
      final response = await _remoteDataSource.getExercises(primeMoverMuscleId, difficultyLevelId);
      return response.exerciseEntities;
    });
  }

  @override
  Future<Result<List<DifficultyLevelEntity>>> getDifficultyLevels({required String primeMoverMuscleId}) {
    return executeApi(() async {
      final response = await _remoteDataSource.getDifficultyLevels(primeMoverMuscleId);
      return response.difficultyLevels;
    });
  }
}
