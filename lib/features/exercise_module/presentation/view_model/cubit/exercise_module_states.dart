import 'package:equatable/equatable.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';

class ExerciseModuleData extends Equatable {
  final List<ExerciseEntity> exercises;
  final int selectedDifficultyIndex;
  final List<DifficultyLevelEntity> difficultyLevels;
  final String primeMoverMuscleId;
  final String pageTitle;
  final String pageDescription;

  const ExerciseModuleData({
    this.exercises = const [],
    this.selectedDifficultyIndex = 0,
    this.difficultyLevels = const [],
    this.primeMoverMuscleId = '',
    this.pageTitle = '',
    this.pageDescription = '',
  });

  ExerciseModuleData copyWith({
    List<ExerciseEntity>? exercises,
    int? selectedDifficultyIndex,
    List<DifficultyLevelEntity>? difficultyLevels,
    String? primeMoverMuscleId,
    String? pageTitle,
    String? pageDescription,
  }) {
    return ExerciseModuleData(
      exercises: exercises ?? this.exercises,
      selectedDifficultyIndex: selectedDifficultyIndex ?? this.selectedDifficultyIndex,
      difficultyLevels: difficultyLevels ?? this.difficultyLevels,
      primeMoverMuscleId: primeMoverMuscleId ?? this.primeMoverMuscleId,
      pageTitle: pageTitle ?? this.pageTitle,
      pageDescription: pageDescription ?? this.pageDescription,
    );
  }

  @override
  List<Object> get props => [
    exercises, 
    selectedDifficultyIndex, 
    difficultyLevels,
    primeMoverMuscleId,
    pageTitle,
    pageDescription,
  ];
}
