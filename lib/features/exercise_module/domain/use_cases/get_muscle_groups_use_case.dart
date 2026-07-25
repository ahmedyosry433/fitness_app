import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMuscleGroupsUseCase {
  final ExerciseRepository repository;

  GetMuscleGroupsUseCase(this.repository);

  Future<Result<List<MuscleGroupEntity>>> call() {
    return repository.getMuscleGroups();
  }
}
