import 'package:fitness/features/exercise_module/api/api_client/exercise_module_api_client.dart';
import 'package:fitness/features/exercise_module/data/models/difficulty_level_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/exercise_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/muscle_group_details_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/muscles_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/random_muscles_response_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class ExerciseRemoteDataSource {
  Future<ExerciseResponseModel> getExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
  );
  Future<DifficultyLevelResponseModel> getDifficultyLevels(
    String primeMoverMuscleId,
  );
  Future<MusclesResponseModel> getMuscleGroups();
  Future<RandomMusclesResponseModel> getRandomMuscles();
  Future<MuscleGroupDetailsResponseModel> getMusclesByGroupId(
    String muscleGroupId,
  );
}

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseModuleApiClient _apiClient;

  ExerciseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ExerciseResponseModel> getExercises(
    String primeMoverMuscleId,
    String difficultyLevelId,
  ) {
    return _apiClient.getExercises(primeMoverMuscleId, difficultyLevelId);
  }

  @override
  Future<DifficultyLevelResponseModel> getDifficultyLevels(
    String primeMoverMuscleId,
  ) {
    return _apiClient.getDifficultyLevels(primeMoverMuscleId);
  }

  @override
  Future<MusclesResponseModel> getMuscleGroups() {
    return _apiClient.getMuscleGroups();
  }

  @override
  Future<RandomMusclesResponseModel> getRandomMuscles() {
    return _apiClient.getRandomMuscles();
  }

  @override
  Future<MuscleGroupDetailsResponseModel> getMusclesByGroupId(
    String muscleGroupId,
  ) {
    return _apiClient.getMusclesByGroupId(muscleGroupId);
  }
}
