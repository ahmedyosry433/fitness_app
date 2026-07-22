import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExercisesUseCase {
  final ExerciseRepository repository;

  GetExercisesUseCase(this.repository);

  Future<Result<List<ExerciseEntity>>> call(int difficultyIndex) async {
    final result = await repository.getAllExercises();
    return result.when(
      success: (data) {
        final levelText = _getLevelText(difficultyIndex);
        final filtered = data?.where((e) => e.level == levelText).toList() ?? [];
        return Success(data: filtered);
      },
      error: (exception) => Error(exception: exception),
    );
  }

  String _getLevelText(int index) {
    switch (index) {
      case 0:
        return 'Beginner';
      case 1:
        return 'Intermediate';
      case 2:
        return 'Advanced';
      default:
        return 'Beginner';
    }
  }
}
