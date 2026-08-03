part of 'workout_cubit.dart';

class WorkoutState extends Equatable {
  final BaseState<List<MuscleGroupEntity>> categoriesState;
  final BaseState<List<ExerciseEntity>> exercisesState;
  final int selectedCategoryIndex;
  final Map<String, List<ExerciseEntity>> categoryCache;
  final String? pendingCategoryId;
  final int activeRequestId;

  const WorkoutState({
    this.categoriesState = const BaseState.initial(),
    this.exercisesState = const BaseState.initial(),
    this.selectedCategoryIndex = 0,
    this.categoryCache = const {},
    this.pendingCategoryId,
    this.activeRequestId = 0,
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
    Map<String, List<ExerciseEntity>>? categoryCache,
    String? pendingCategoryId,
    int? activeRequestId,
  }) {
    return WorkoutState(
      categoriesState: categoriesState ?? this.categoriesState,
      exercisesState: exercisesState ?? this.exercisesState,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      categoryCache: categoryCache ?? this.categoryCache,
      pendingCategoryId: pendingCategoryId ?? this.pendingCategoryId,
      activeRequestId: activeRequestId ?? this.activeRequestId,
    );
  }

  @override
  List<Object?> get props => [
        categoriesState,
        exercisesState,
        selectedCategoryIndex,
        categoryCache,
        pendingCategoryId,
        activeRequestId,
      ];
}
