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

part 'workout_state.dart';
part 'workout_events.dart';
part 'workout_ui_events.dart';

@injectable
class WorkoutCubit extends BaseCubit<WorkoutState, WorkoutUiEvent> {
  static const String fullBodyCategoryId = 'full_body';

  final GetMuscleGroupsUseCase _getMuscleGroupsUseCase;
  final GetMusclesByGroupUseCase _getMusclesByGroupUseCase;
  final GetExercisesUseCase _getExercisesUseCase;
  final GetRandomMusclesUseCase _getRandomMusclesUseCase;

  bool _isLoadingCategory = false;

  WorkoutCubit(
    this._getMuscleGroupsUseCase,
    this._getMusclesByGroupUseCase,
    this._getExercisesUseCase,
    this._getRandomMusclesUseCase,
  ) : super(const WorkoutState());

  String? _pendingCategoryId;

  Future<void> doIntent(WorkoutEvent event) async => switch (event) {
        InitWorkoutEvent(:final initialCategoryId) => _init(initialCategoryId),
        LoadWorkoutCategoryEvent(:final index) => _loadCategory(index),
        SelectCategoryByIdEvent(:final categoryId) => _selectCategoryById(categoryId),
      };

  Future<void> _init(String? initialCategoryId) async {
    if (initialCategoryId != null && initialCategoryId.isNotEmpty) {
      _pendingCategoryId = initialCategoryId;
    }

    if (!state.categoriesState.isSuccess) {
      emit(state.copyWith(categoriesState: const BaseState.loading()));
    }

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
        final target = _pendingCategoryId ?? initialCategoryId;
        if (target != null && target.isNotEmpty) {
          selectedIndex = _findCategoryIndex(categories, target);
        }
        _pendingCategoryId = null;

        emit(
          state.copyWith(
            categoriesState: BaseState.success(categories),
            selectedCategoryIndex: selectedIndex,
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
      _pendingCategoryId = categoryId;
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

  static const String defaultDifficultyLevelId = '69d982ed85f6bfa972bf2216';
  final Map<String, List<MuscleEntity>> _categoryCache = {};

  Future<void> _loadCategory(int index) async {
    if (_isLoadingCategory) return;
    if (index < 0 || index >= state.categories.length) return;

    final category = state.categories[index];

    if (_categoryCache.containsKey(category.id)) {
      emit(
        state.copyWith(
          selectedCategoryIndex: index,
          musclesState: BaseState.success(_categoryCache[category.id]!),
        ),
      );
      return;
    }

    _isLoadingCategory = true;

    emit(
      state.copyWith(
        selectedCategoryIndex: index,
        musclesState: const BaseState.loading(),
      ),
    );

    final Result<List<MuscleEntity>> musclesResult =
        category.id == fullBodyCategoryId
            ? await _loadFullBodyMuscles()
            : await _loadGroupMuscles(category.id);

    if (isClosed) {
      _isLoadingCategory = false;
      return;
    }

    musclesResult.when(
      success: (muscles) {
        final list = muscles ?? const [];
        _categoryCache[category.id] = list;
        emit(
          state.copyWith(
            selectedCategoryIndex: index,
            musclesState: BaseState.success(list),
          ),
        );
      },
      error: (exception) {
        final error = exception ??
            Exception(LocaleKeys.exercise_failed_to_load.tr(args: ['']));
        emit(
          state.copyWith(
            selectedCategoryIndex: index,
            musclesState: BaseState.error(error),
          ),
        );
        emitEvent(WorkoutErrorUiEvent(error.toString()));
      },
    );

    _isLoadingCategory = false;
  }

  Future<Result<List<MuscleEntity>>> _loadFullBodyMuscles() async {
    final groups = state.categories.where((c) => c.id != fullBodyCategoryId).toList();

    if (groups.isEmpty) return const Success(data: <MuscleEntity>[]);

    final results = await Future.wait(
      groups.map((group) => _getMusclesByGroupUseCase(muscleGroupId: group.id)),
    );

    final allMuscles = <MuscleEntity>[];
    for (final result in results) {
      if (result is Success<List<MuscleEntity>>) {
        allMuscles.addAll((result as Success<List<MuscleEntity>>).data ?? []);
      }
    }

    final uniqueMuscles = {for (var m in allMuscles) m.id: m}.values.toList();

    return Success(data: uniqueMuscles);
  }

  Future<Result<List<MuscleEntity>>> _loadGroupMuscles(
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
    return Success(data: muscles);
  }
}
