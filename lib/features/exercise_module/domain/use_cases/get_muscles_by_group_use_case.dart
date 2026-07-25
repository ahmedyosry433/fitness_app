import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMusclesByGroupUseCase {
  final ExerciseRepository repository;

  GetMusclesByGroupUseCase(this.repository);

  Future<Result<List<MuscleEntity>>> call({required String muscleGroupId}) {
    return repository.getMusclesByGroupId(muscleGroupId: muscleGroupId);
  }
}
