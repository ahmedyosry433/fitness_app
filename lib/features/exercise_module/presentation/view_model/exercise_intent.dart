import 'package:equatable/equatable.dart';

abstract class ExerciseIntent extends Equatable {
  const ExerciseIntent();

  @override
  List<Object> get props => [];
}

class InitExerciseModuleIntent extends ExerciseIntent {
  final String primeMoverMuscleId;
  final String pageTitle;
  final String pageDescription;

  const InitExerciseModuleIntent({
    required this.primeMoverMuscleId,
    required this.pageTitle,
    required this.pageDescription,
  });

  @override
  List<Object> get props => [primeMoverMuscleId, pageTitle, pageDescription];
}

class LoadExercisesIntent extends ExerciseIntent {
  final int difficultyIndex;

  const LoadExercisesIntent(this.difficultyIndex);

  @override
  List<Object> get props => [difficultyIndex];
}
