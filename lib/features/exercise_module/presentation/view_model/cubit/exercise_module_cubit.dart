import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_exercises_use_case.dart';
import 'package:injectable/injectable.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/config/base_state/base_state.dart';

import '../exercise_intent.dart';
import 'exercise_module_states.dart';

@injectable
class ExerciseModuleCubit extends Cubit<BaseState<ExerciseModuleUIModel>> {
  final GetExercisesUseCase getExercisesUseCase;
  final GetDifficultyLevelsUseCase getDifficultyLevelsUseCase;

  ExerciseModuleCubit(
    this.getExercisesUseCase,
    this.getDifficultyLevelsUseCase,
  ) : super(const BaseState.initial());

  ExerciseModuleUIModel get _data => state.data ?? const ExerciseModuleUIModel();

  void processIntent(ExerciseIntent intent) {
    if (intent is InitExerciseModuleIntent) {
      _init(
        primeMoverMuscleId: intent.primeMoverMuscleId,
        pageTitle: intent.pageTitle,
        pageDescription: intent.pageDescription,
      );
    } else if (intent is LoadExercisesIntent) {
      _loadExercises(intent.difficultyIndex);
    }
  }

  Future<void> _init({
    required String primeMoverMuscleId,
    required String pageTitle,
    required String pageDescription,
  }) async {
    emit(BaseState.all(
        state: StateType.loading,
        data: _data.copyWith(
          primeMoverMuscleId: primeMoverMuscleId,
          pageTitle: pageTitle,
          pageDescription: pageDescription,
        ),
        exception: null));
    
    final levelsResult = await getDifficultyLevelsUseCase(primeMoverMuscleId);
    
    levelsResult.when(
      success: (levels) {
        if (levels == null || levels.isEmpty) {
          emit(BaseState.all(
              state: StateType.error,
              data: _data,
              exception: Exception(LocaleKeys.exercise_no_exercises_found.tr())));
          return;
        }
        emit(BaseState.all(
            state: StateType.success,
            data: _data.copyWith(difficultyLevels: levels),
            exception: null));
        _loadExercises(0);
      },
      error: (exception) {
        emit(BaseState.all(
            state: StateType.error,
            data: _data,
            exception: exception));
      },
    );
  }

  Future<void> _loadExercises(int difficultyIndex) async {
    if (_data.difficultyLevels.isEmpty) return;

    emit(BaseState.all(
        state: StateType.loading,
        data: _data.copyWith(selectedDifficultyIndex: difficultyIndex),
        exception: null));

    // Ensure index is within bounds, fallback to first if not
    final safeIndex = (difficultyIndex >= 0 && difficultyIndex < _data.difficultyLevels.length) 
        ? difficultyIndex 
        : 0;
    final difficultyLevelId = _data.difficultyLevels[safeIndex].id;

    final result = await getExercisesUseCase(
      primeMoverMuscleId: _data.primeMoverMuscleId,
      difficultyLevelId: difficultyLevelId,
    );

    result.when(
      success: (exercises) {
        emit(BaseState.all(
            state: StateType.success,
            data: _data.copyWith(exercises: exercises),
            exception: null));
      },
      error: (exception) {
        emit(BaseState.all(
            state: StateType.error,
            data: _data,
            exception: exception));
      },
    );
  }
}
