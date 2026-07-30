import 'package:equatable/equatable.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';

class HomeUIModel extends Equatable {
  final List<MuscleEntity> randomMuscles;
  final List<MuscleGroupEntity> muscleGroups;
  final List<MuscleEntity> groupMuscles;
  final String selectedMuscleGroupId;
  final bool isLoadingGroupMuscles;
  final String userName;
  final String? userPhoto;

  const HomeUIModel({
    this.randomMuscles = const [],
    this.muscleGroups = const [],
    this.groupMuscles = const [],
    this.selectedMuscleGroupId = '',
    this.isLoadingGroupMuscles = false,
    this.userName = '',
    this.userPhoto,
  });

  HomeUIModel copyWith({
    List<MuscleEntity>? randomMuscles,
    List<MuscleGroupEntity>? muscleGroups,
    List<MuscleEntity>? groupMuscles,
    String? selectedMuscleGroupId,
    bool? isLoadingGroupMuscles,
    String? userName,
    String? userPhoto,
  }) {
    return HomeUIModel(
      randomMuscles: randomMuscles ?? this.randomMuscles,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      groupMuscles: groupMuscles ?? this.groupMuscles,
      selectedMuscleGroupId:
          selectedMuscleGroupId ?? this.selectedMuscleGroupId,
      isLoadingGroupMuscles:
          isLoadingGroupMuscles ?? this.isLoadingGroupMuscles,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
    );
  }

  @override
  List<Object?> get props => [
        randomMuscles,
        muscleGroups,
        groupMuscles,
        selectedMuscleGroupId,
        isLoadingGroupMuscles,
        userName,
        userPhoto,
      ];
}
