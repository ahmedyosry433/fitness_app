import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';

abstract interface class ExerciseRepository {
  Future<Result<List<ExerciseEntity>>> getAllExercises(
      {required String primeMoverMuscleId, required String difficultyLevelId});
  Future<Result<List<DifficultyLevelEntity>>> getDifficultyLevels({required String primeMoverMuscleId});
}
