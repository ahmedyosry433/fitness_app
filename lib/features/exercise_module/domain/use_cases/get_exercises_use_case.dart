import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExercisesUseCase {
  final ExerciseRepository repository;

  GetExercisesUseCase(this.repository);

  Future<Result<List<ExerciseEntity>>> call(
      {required String primeMoverMuscleId, required String difficultyLevelId}) async {
    return await repository.getAllExercises(
        primeMoverMuscleId: primeMoverMuscleId, difficultyLevelId: difficultyLevelId);
  }
}
