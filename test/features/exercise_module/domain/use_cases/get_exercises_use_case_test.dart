import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_exercises_use_case.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}

void main() {
  late GetExercisesUseCase useCase;
  late MockExerciseRepository mockRepository;

  setUp(() {
    mockRepository = MockExerciseRepository();
    useCase = GetExercisesUseCase(mockRepository);
  });

  group('GetExercisesUseCase Tests', () {
    const tPrimeMoverMuscleId = 'muscle_id';
    const tDifficultyLevelId = 'difficulty_id';

    test('should return list of ExerciseEntity when repository returns success', () async {
      // Arrange
      final tResult = Success<List<ExerciseEntity>>(data: []);
      when(() => mockRepository.getAllExercises(
            primeMoverMuscleId: tPrimeMoverMuscleId,
            difficultyLevelId: tDifficultyLevelId,
          )).thenAnswer((_) async => tResult);

      // Act
      final result = await useCase(
        primeMoverMuscleId: tPrimeMoverMuscleId,
        difficultyLevelId: tDifficultyLevelId,
      );

      // Assert
      expect(result, equals(tResult));
      verify(() => mockRepository.getAllExercises(
            primeMoverMuscleId: tPrimeMoverMuscleId,
            difficultyLevelId: tDifficultyLevelId,
          )).called(1);
    });
  });
}
