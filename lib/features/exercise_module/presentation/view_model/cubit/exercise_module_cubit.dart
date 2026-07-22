import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_exercises_use_case.dart';
import 'package:injectable/injectable.dart';

import 'exercise_module_states.dart';

@injectable
class ExerciseModuleCubit extends Cubit<ExerciseModuleState> {
  final GetExercisesUseCase getExercisesUseCase;

  ExerciseModuleCubit(
    this.getExercisesUseCase,
  ) : super(const ExerciseModuleState());

  void init() {
    loadExercises(0);
  }

  Future<void> loadExercises(int difficultyIndex) async {
    emit(state.copyWith(
      status: ExerciseStatus.loading,
      selectedDifficultyIndex: difficultyIndex,
    ));

    final result = await getExercisesUseCase(difficultyIndex);

    result.when(
      success: (exercises) {
        emit(state.copyWith(
          status: ExerciseStatus.success,
          exercises: exercises,
        ));
      },
      error: (exception) {
        emit(state.copyWith(
          status: ExerciseStatus.failure,
          errorMessage: exception?.toString() ?? 'An unknown error occurred',
        ));
      },
    );
  }
}
