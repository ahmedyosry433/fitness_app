part of 'workout_cubit.dart';

sealed class WorkoutEvent {
  const WorkoutEvent();
}

class InitWorkoutEvent extends WorkoutEvent {
  final String? initialCategoryId;

  const InitWorkoutEvent({this.initialCategoryId});
}

class LoadWorkoutCategoryEvent extends WorkoutEvent {
  final int index;

  const LoadWorkoutCategoryEvent(this.index);
}

class SelectCategoryByIdEvent extends WorkoutEvent {
  final String categoryId;

  const SelectCategoryByIdEvent(this.categoryId);
}
