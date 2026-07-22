import 'package:equatable/equatable.dart';

abstract class ExerciseIntent extends Equatable {
  const ExerciseIntent();

  @override
  List<Object> get props => [];
}

class LoadExercisesIntent extends ExerciseIntent {}
