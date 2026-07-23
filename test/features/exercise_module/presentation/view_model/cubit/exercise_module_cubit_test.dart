import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_exercises_use_case.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';

class MockGetExercisesUseCase extends Mock implements GetExercisesUseCase {}
class MockGetDifficultyLevelsUseCase extends Mock implements GetDifficultyLevelsUseCase {}

void main() {
  late ExerciseModuleCubit cubit;
  late MockGetExercisesUseCase mockGetExercisesUseCase;
  late MockGetDifficultyLevelsUseCase mockGetDifficultyLevelsUseCase;

  setUp(() {
    mockGetExercisesUseCase = MockGetExercisesUseCase();
    mockGetDifficultyLevelsUseCase = MockGetDifficultyLevelsUseCase();
    cubit = ExerciseModuleCubit(mockGetExercisesUseCase, mockGetDifficultyLevelsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('ExerciseModuleCubit Tests', () {
    const tPrimeMoverMuscleId = 'muscle_id';
    final tDifficultyLevels = [
      const DifficultyLevelEntity(id: '1', name: 'Beginner'),
      const DifficultyLevelEntity(id: '2', name: 'Advanced'),
    ];
    final tExercises = [
      const ExerciseEntity(
        id: '1',
        title: 'Push Up',
        description: 'A push up',
        videoUrl: 'https://video.com',
        thumbnailUrl: 'https://thumb.com',
        time: '10',
        calories: '50',
        level: 'Beginner',
      ),
    ];

    test('initial state should be BaseState.initial()', () {
      expect(cubit.state, equals(const BaseState<ExerciseModuleData>.initial()));
    });

    blocTest<ExerciseModuleCubit, BaseState<ExerciseModuleData>>(
      'emits [loading, success] when InitExerciseModuleIntent is processed successfully',
      build: () {
        when(() => mockGetDifficultyLevelsUseCase(tPrimeMoverMuscleId))
            .thenAnswer((_) async => Success<List<DifficultyLevelEntity>>(data: tDifficultyLevels));
        when(() => mockGetExercisesUseCase(
              primeMoverMuscleId: tPrimeMoverMuscleId,
              difficultyLevelId: tDifficultyLevels[0].id,
            )).thenAnswer((_) async => Success<List<ExerciseEntity>>(data: tExercises));
        return cubit;
      },
      act: (cubit) => cubit.processIntent(const InitExerciseModuleIntent(primeMoverMuscleId: tPrimeMoverMuscleId, pageTitle: 'Test Title', pageDescription: 'Test Description')),
      expect: () => [
        isA<BaseState<ExerciseModuleData>>().having((s) => s.state, 'state', StateType.loading),
        isA<BaseState<ExerciseModuleData>>().having((s) => s.state, 'state', StateType.success)
            .having((s) => s.data?.difficultyLevels, 'difficultyLevels', tDifficultyLevels),
        isA<BaseState<ExerciseModuleData>>().having((s) => s.state, 'state', StateType.loading),
        isA<BaseState<ExerciseModuleData>>().having((s) => s.state, 'state', StateType.success)
            .having((s) => s.data?.exercises, 'exercises', tExercises),
      ],
    );

    blocTest<ExerciseModuleCubit, BaseState<ExerciseModuleData>>(
      'emits [error] when InitExerciseModuleIntent fails',
      build: () {
        when(() => mockGetDifficultyLevelsUseCase(tPrimeMoverMuscleId))
            .thenAnswer((_) async => Error<List<DifficultyLevelEntity>>(exception: Exception('Error')));
        return cubit;
      },
      act: (cubit) => cubit.processIntent(const InitExerciseModuleIntent(primeMoverMuscleId: tPrimeMoverMuscleId, pageTitle: 'Test Title', pageDescription: 'Test Description')),
      expect: () => [
        isA<BaseState<ExerciseModuleData>>().having((s) => s.state, 'state', StateType.loading),
        isA<BaseState<ExerciseModuleData>>().having((s) => s.state, 'state', StateType.error),
      ],
    );
  });
}
