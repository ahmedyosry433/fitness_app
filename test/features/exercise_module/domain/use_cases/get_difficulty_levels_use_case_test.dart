import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/repositories/exercise_repository.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_difficulty_levels_use_case.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}

void main() {
  late GetDifficultyLevelsUseCase useCase;
  late MockExerciseRepository mockRepository;

  setUp(() {
    mockRepository = MockExerciseRepository();
    useCase = GetDifficultyLevelsUseCase(mockRepository);
  });

  group('GetDifficultyLevelsUseCase Tests', () {
    const tPrimeMoverMuscleId = 'muscle_id';

    test('should return list of DifficultyLevelEntity when repository returns success', () async {
      // Arrange
      final tResult = Success<List<DifficultyLevelEntity>>(data: []);
      when(() => mockRepository.getDifficultyLevels(
            primeMoverMuscleId: tPrimeMoverMuscleId,
          )).thenAnswer((_) async => tResult);

      // Act
      final result = await useCase(tPrimeMoverMuscleId);

      // Assert
      expect(result, equals(tResult));
      verify(() => mockRepository.getDifficultyLevels(
            primeMoverMuscleId: tPrimeMoverMuscleId,
          )).called(1);
    });
  });
}
