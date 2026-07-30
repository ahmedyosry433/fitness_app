import 'package:equatable/equatable.dart';

sealed class HomeIntent extends Equatable {
  const HomeIntent();

  @override
  List<Object?> get props => [];
}

class LoadHomeIntent extends HomeIntent {
  const LoadHomeIntent();
}

class SelectMuscleGroupIntent extends HomeIntent {
  final String muscleGroupId;

  const SelectMuscleGroupIntent(this.muscleGroupId);

  @override
  List<Object?> get props => [muscleGroupId];
}
