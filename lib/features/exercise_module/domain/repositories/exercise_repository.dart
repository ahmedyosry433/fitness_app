import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';

abstract interface class ExerciseRepository {
  Future<Result<List<ExerciseEntity>>> getAllExercises({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  });
  Future<Result<List<DifficultyLevelEntity>>> getDifficultyLevels({
    required String primeMoverMuscleId,
  });

  Future<Result<List<MuscleGroupEntity>>> getMuscleGroups();

  Future<Result<List<MuscleEntity>>> getRandomMuscles();

  Future<Result<List<MuscleEntity>>> getMusclesByGroupId({
    required String muscleGroupId,
  });
}
