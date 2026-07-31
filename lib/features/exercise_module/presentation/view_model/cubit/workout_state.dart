part of 'workout_cubit.dart';

class WorkoutState extends Equatable {
  final BaseState<List<MuscleGroupEntity>> categoriesState;
  final BaseState<List<MuscleEntity>> musclesState;
  final int selectedCategoryIndex;

  const WorkoutState({
    this.categoriesState = const BaseState.initial(),
    this.musclesState = const BaseState.initial(),
    this.selectedCategoryIndex = 0,
  });

  List<MuscleGroupEntity> get categories => categoriesState.data ?? const [];

  List<MuscleEntity> get muscles => musclesState.data ?? const [];

  bool get isLoadingCategories =>
      categoriesState.isLoading || categoriesState.isInitial;

  bool get isLoadingMuscles =>
      musclesState.isLoading || musclesState.isInitial;

  WorkoutState copyWith({
    BaseState<List<MuscleGroupEntity>>? categoriesState,
    BaseState<List<MuscleEntity>>? musclesState,
    int? selectedCategoryIndex,
  }) {
    return WorkoutState(
      categoriesState: categoriesState ?? this.categoriesState,
      musclesState: musclesState ?? this.musclesState,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props => [
        categoriesState,
        musclesState,
        selectedCategoryIndex,
      ];
}
