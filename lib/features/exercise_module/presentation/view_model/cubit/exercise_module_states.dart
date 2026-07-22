import 'package:equatable/equatable.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';

enum ExerciseStatus { initial, loading, success, failure }

class ExerciseModuleState extends Equatable {
  final ExerciseStatus status;
  final List<ExerciseEntity> exercises;
  final int selectedDifficultyIndex;
  final String errorMessage;

  const ExerciseModuleState({
    this.status = ExerciseStatus.initial,
    this.exercises = const [],
    this.selectedDifficultyIndex = 0,
    this.errorMessage = '',
  });

  ExerciseModuleState copyWith({
    ExerciseStatus? status,
    List<ExerciseEntity>? exercises,
    int? selectedDifficultyIndex,
    String? errorMessage,
  }) {
    return ExerciseModuleState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      selectedDifficultyIndex: selectedDifficultyIndex ?? this.selectedDifficultyIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status, 
    exercises, 
    selectedDifficultyIndex, 
    errorMessage
  ];
}
