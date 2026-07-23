import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDifficultyLevelsUseCase {
  final ExerciseRepository repository;

  GetDifficultyLevelsUseCase(this.repository);

  Future<Result<List<DifficultyLevelEntity>>> call(String primeMoverMuscleId) {
    return repository.getDifficultyLevels(
      primeMoverMuscleId: primeMoverMuscleId,
    );
  }
}
