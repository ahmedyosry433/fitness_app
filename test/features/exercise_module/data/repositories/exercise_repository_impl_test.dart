import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/data/datasources/exercise_remote_data_source.dart';
import 'package:fitness/features/exercise_module/data/repositories/exercise_repository_impl.dart';
import 'package:fitness/features/exercise_module/data/models/difficulty_level_response_model.dart';
import 'package:fitness/features/exercise_module/data/models/exercise_response_model.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/features/exercise_module/data/models/exercise_model.dart';
import 'package:fitness/features/exercise_module/data/models/difficulty_level_dtos.dart';

class MockExerciseRemoteDataSource extends Mock implements ExerciseRemoteDataSource {}
class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late ExerciseRepositoryImpl repository;
  late MockExerciseRemoteDataSource mockRemoteDataSource;
  late MockInternetConnection mockInternetConnection;

  setUp(() async {
    mockRemoteDataSource = MockExerciseRemoteDataSource();
    mockInternetConnection = MockInternetConnection();
    
    await getIt.reset();
    getIt.registerSingleton<InternetConnection>(mockInternetConnection);
    when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);

    repository = ExerciseRepositoryImpl(mockRemoteDataSource);
  });

  group('ExerciseRepositoryImpl Tests', () {
    const String tPrimeMoverMuscleId = 'muscle_id';
    const String tDifficultyLevelId = 'difficulty_id';

    test('should return list of ExerciseEntity when getExercises is successful', () async {
      // Arrange
      final tResponse = ExerciseResponseModel(
        message: 'Success',
        exercises: [
          ExerciseModel(
            id: '1',
            title: 'Push Up',
            description: 'A push up',
            videoUrl: 'https://video.com',
            thumbnailUrl: 'https://thumb.com',
            time: '10',
            calories: '50',
            level: 'Beginner',
          ),
        ],
      );
      when(() => mockRemoteDataSource.getExercises(tPrimeMoverMuscleId, tDifficultyLevelId))
          .thenAnswer((_) async => tResponse);

      // Act
      final result = await repository.getAllExercises(
        primeMoverMuscleId: tPrimeMoverMuscleId,
        difficultyLevelId: tDifficultyLevelId,
      );

      // Assert
      expect(result, isA<Success<List<ExerciseEntity>>>());
      result.when(
        success: (data) {
          expect(data, equals(tResponse.exerciseEntities));
        },
        error: (_) => fail('Should return success'),
      );
      verify(() => mockRemoteDataSource.getExercises(tPrimeMoverMuscleId, tDifficultyLevelId)).called(1);
    });

    test('should return list of DifficultyLevelEntity when getDifficultyLevels is successful', () async {
      // Arrange
      final tResponse = DifficultyLevelResponseModel(
        message: 'Success',
        levels: [
          DifficultyLevelNameDto(id: '1', name: 'Beginner'),
        ],
      );
      when(() => mockRemoteDataSource.getDifficultyLevels(tPrimeMoverMuscleId))
          .thenAnswer((_) async => tResponse);

      // Act
      final result = await repository.getDifficultyLevels(
        primeMoverMuscleId: tPrimeMoverMuscleId,
      );

      // Assert
      expect(result, isA<Success<List<DifficultyLevelEntity>>>());
      result.when(
        success: (data) {
          expect(data, equals(tResponse.difficultyLevels));
        },
        error: (_) => fail('Should return success'),
      );
      verify(() => mockRemoteDataSource.getDifficultyLevels(tPrimeMoverMuscleId)).called(1);
    });
  });
}
