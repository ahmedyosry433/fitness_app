import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/api/api_client/exercise_module_api_client.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseModuleApiClient _apiClient;

  ExerciseRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<ExerciseEntity>>> getAllExercises() async {
    try {
      final response = await _apiClient.getExercises();
      return Success(data: response.exercises ?? []);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<DifficultyLevelEntity>>> getDifficultyLevels({required String primeMoverMuscleId}) async {
    try {
      final response = await _apiClient.getDifficultyLevels(primeMoverMuscleId);
      return Success(data: response.difficultyLevels);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }
}
