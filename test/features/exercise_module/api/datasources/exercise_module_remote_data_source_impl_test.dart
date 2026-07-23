import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness/features/exercise_module/api/api_client/exercise_module_api_client.dart';
import 'package:fitness/features/exercise_module/data/datasources/exercise_remote_data_source.dart';
import 'package:fitness/features/exercise_module/data/models/difficulty_level_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/exercise_response_model.dart';

class MockExerciseModuleApiClient extends Mock implements ExerciseModuleApiClient {}

void main() {
  late ExerciseRemoteDataSourceImpl dataSource;
  late MockExerciseModuleApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockExerciseModuleApiClient();
    dataSource = ExerciseRemoteDataSourceImpl(mockApiClient);
  });

  group('ExerciseRemoteDataSourceImpl Tests', () {
    const tPrimeMoverMuscleId = 'muscle_id';
    const tDifficultyLevelId = 'difficulty_id';

    test('should return ExerciseResponseModel when api call is successful', () async {
      // Arrange
      final tResponse = ExerciseResponseModel(
        message: 'Success',
        exercises: [],
      );
      when(() => mockApiClient.getExercises(tPrimeMoverMuscleId, tDifficultyLevelId))
          .thenAnswer((_) async => tResponse);

      // Act
      final result = await dataSource.getExercises(tPrimeMoverMuscleId, tDifficultyLevelId);

      // Assert
      expect(result, equals(tResponse));
      verify(() => mockApiClient.getExercises(tPrimeMoverMuscleId, tDifficultyLevelId)).called(1);
    });

    test('should return DifficultyLevelResponseModel when api call is successful', () async {
      // Arrange
      final tResponse = DifficultyLevelResponseModel(
        message: 'Success',
        data: [],
      );
      when(() => mockApiClient.getDifficultyLevels(tPrimeMoverMuscleId))
          .thenAnswer((_) async => tResponse);

      // Act
      final result = await dataSource.getDifficultyLevels(tPrimeMoverMuscleId);

      // Assert
      expect(result, equals(tResponse));
      verify(() => mockApiClient.getDifficultyLevels(tPrimeMoverMuscleId)).called(1);
    });
  });
}
