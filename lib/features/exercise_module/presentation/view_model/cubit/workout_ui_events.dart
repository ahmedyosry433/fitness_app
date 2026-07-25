part of 'workout_cubit.dart';

sealed class WorkoutUiEvent {
  const WorkoutUiEvent();
}

class WorkoutErrorUiEvent extends WorkoutUiEvent {
  final String message;

  const WorkoutErrorUiEvent(this.message);
}
