import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_exercises_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:injectable/injectable.dart';

part 'workout_events.dart';
part 'workout_state.dart';
part 'workout_ui_events.dart';

@injectable
class WorkoutCubit extends BaseCubit<WorkoutState, WorkoutUiEvent> {
  static const String fullBodyCategoryId = 'full_body';
  static const String defaultDifficultyLevelId = '69d982ed85f6bfa972bf2216';

  final GetMuscleGroupsUseCase _getMuscleGroupsUseCase;
  final GetMusclesByGroupUseCase _getMusclesByGroupUseCase;
  final GetExercisesUseCase _getExercisesUseCase;
  final GetRandomMusclesUseCase _getRandomMusclesUseCase;

  WorkoutCubit(
    this._getMuscleGroupsUseCase,
    this._getMusclesByGroupUseCase,
    this._getExercisesUseCase,
    this._getRandomMusclesUseCase,
  ) : super(const WorkoutState());

  @override
  Future<void> doAction(covariant WorkoutEvent event) async => switch (event) {
        InitWorkoutEvent(:final initialCategoryId) => _init(initialCategoryId),
        LoadWorkoutCategoryEvent(:final index) => _loadCategory(index),
        SelectCategoryByIdEvent(:final categoryId) =>
          _selectCategoryById(categoryId),
      };

  Future<void> doIntent(WorkoutEvent event) => doAction(event);

  Future<void> _init(String? initialCategoryId) async {
    final pending = initialCategoryId ?? state.pendingCategoryId;

    emit(
      state.copyWith(
        pendingCategoryId: pending,
        categoriesState: const BaseState.loading(),
      ),
    );

    final groupsResult = await _getMuscleGroupsUseCase();
    if (isClosed) return;

    groupsResult.when(
      success: (groups) {
        final categories = <MuscleGroupEntity>[
          MuscleGroupEntity(
            id: fullBodyCategoryId,
            name: LocaleKeys.exercise_full_body.tr(),
          ),
          ...?groups,
        ];

        int selectedIndex = 0;
        final target = state.pendingCategoryId ?? initialCategoryId;
        if (target != null && target.isNotEmpty) {
          selectedIndex = _findCategoryIndex(categories, target);
        }

        emit(
          state.copyWith(
            categoriesState: BaseState.success(categories),
            selectedCategoryIndex: selectedIndex,
            pendingCategoryId: null,
          ),
        );
        _loadCategory(selectedIndex);
      },
      error: (exception) {
        final error = exception ??
            Exception(LocaleKeys.exercise_failed_to_load.tr(args: ['']));
        emit(state.copyWith(categoriesState: BaseState.error(error)));
        emitEvent(WorkoutErrorUiEvent(error.toString()));
      },
    );
  }

  void _selectCategoryById(String categoryId) {
    if (categoryId.isEmpty) return;

    if (!state.categoriesState.isSuccess) {
      emit(state.copyWith(pendingCategoryId: categoryId));
      return;
    }

    final index = _findCategoryIndex(state.categories, categoryId);
    if (index != state.selectedCategoryIndex) {
      _loadCategory(index);
    }
  }

  int _findCategoryIndex(List<MuscleGroupEntity> categories, String target) {
    if (target.isEmpty) return 0;

    final indexById = categories.indexWhere((c) => c.id == target);
    if (indexById != -1) return indexById;

    final indexByName = categories.indexWhere(
      (c) => c.name.trim().toLowerCase() == target.trim().toLowerCase(),
    );
    if (indexByName != -1) return indexByName;

    return 0;
  }

  Future<void> _loadCategory(int index) async {
    if (index < 0 || index >= state.categories.length) return;

    final category = state.categories[index];

    if (state.categoryCache.containsKey(category.id)) {
      emit(
        state.copyWith(
          selectedCategoryIndex: index,
          exercisesState: BaseState.success(state.categoryCache[category.id]!),
        ),
      );
      return;
    }

    final nextRequestId = state.activeRequestId + 1;
    emit(
      state.copyWith(
        selectedCategoryIndex: index,
        activeRequestId: nextRequestId,
        exercisesState: const BaseState.loading(),
      ),
    );

    final exercisesResult = category.id == fullBodyCategoryId
        ? await _loadFullBodyExercises()
        : await _loadGroupExercises(category.id);

    if (nextRequestId != state.activeRequestId || isClosed) return;

    exercisesResult.when(
      success: (exercises) {
        final list = exercises ?? const [];
        final updatedCache =
            Map<String, List<ExerciseEntity>>.from(state.categoryCache)
              ..[category.id] = list;
        emit(
          state.copyWith(
            categoryCache: updatedCache,
            exercisesState: BaseState.success(list),
          ),
        );
      },
      error: (exception) {
        final error = exception ??
            Exception(LocaleKeys.exercise_failed_to_load.tr(args: ['']));
        emit(state.copyWith(exercisesState: BaseState.error(error)));
        emitEvent(WorkoutErrorUiEvent(error.toString()));
      },
    );
  }

  Future<Result<List<ExerciseEntity>>> _loadFullBodyExercises() async {
    final randomResult = await _getRandomMusclesUseCase();

    if (randomResult is Error<List<MuscleEntity>>) {
      return Error(exception: randomResult.exception);
    }

    final muscles =
        (randomResult as Success<List<MuscleEntity>>).data ?? const [];
    if (muscles.isEmpty) return const Success(data: <ExerciseEntity>[]);

    final results = await Future.wait(
      muscles.take(4).map((m) => _fetchExercisesForMuscle(m.id)),
    );

    return _combineExerciseResults(results, shuffleResult: true);
  }

  Future<Result<List<ExerciseEntity>>> _loadGroupExercises(
    String groupId,
  ) async {
    final musclesResult = await _getMusclesByGroupUseCase(
      muscleGroupId: groupId,
    );

    if (musclesResult is Error<List<MuscleEntity>>) {
      return Error(exception: musclesResult.exception);
    }

    final muscles =
        (musclesResult as Success<List<MuscleEntity>>).data ?? const [];
    if (muscles.isEmpty) return const Success(data: <ExerciseEntity>[]);

    final results = await Future.wait(
      muscles.map((m) => _fetchExercisesForMuscle(m.id)),
    );

    return _combineExerciseResults(results);
  }

  Future<Result<List<ExerciseEntity>>> _fetchExercisesForMuscle(
    String muscleId,
  ) {
    return _getExercisesUseCase(
      primeMoverMuscleId: muscleId,
      difficultyLevelId: defaultDifficultyLevelId,
    );
  }

  Result<List<ExerciseEntity>> _combineExerciseResults(
    List<Result<List<ExerciseEntity>>> results, {
    bool shuffleResult = false,
  }) {
    final allExercises = <ExerciseEntity>[];

    for (final result in results) {
      if (result is Success<List<ExerciseEntity>>) {
        if (result.data != null) {
          allExercises.addAll(result.data!);
        }
      } else if (result is Error<List<ExerciseEntity>>) {
        return Error(exception: result.exception);
      }
    }

    if (shuffleResult) {
      allExercises.shuffle();
    }

    return Success(data: allExercises);
  }
}
