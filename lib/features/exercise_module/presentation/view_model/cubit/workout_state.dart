part of 'workout_cubit.dart';

class WorkoutState extends Equatable {
  final BaseState<List<MuscleGroupEntity>> categoriesState;
  final BaseState<List<ExerciseEntity>> exercisesState;
  final int selectedCategoryIndex;

  const WorkoutState({
    this.categoriesState = const BaseState.initial(),
    this.exercisesState = const BaseState.initial(),
    this.selectedCategoryIndex = 0,
  });

  List<MuscleGroupEntity> get categories => categoriesState.data ?? const [];

  List<ExerciseEntity> get exercises => exercisesState.data ?? const [];

  bool get isLoadingCategories =>
      categoriesState.isLoading || categoriesState.isInitial;

  bool get isLoadingExercises =>
      exercisesState.isLoading || exercisesState.isInitial;

  WorkoutState copyWith({
    BaseState<List<MuscleGroupEntity>>? categoriesState,
    BaseState<List<ExerciseEntity>>? exercisesState,
    int? selectedCategoryIndex,
  }) {
    return WorkoutState(
      categoriesState: categoriesState ?? this.categoriesState,
      exercisesState: exercisesState ?? this.exercisesState,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props => [
        categoriesState,
        exercisesState,
        selectedCategoryIndex,
      ];
}
