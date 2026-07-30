import 'package:fitness/features/exercise_module/data/models/muscle_group_model.dart';
import 'package:fitness/features/exercise_module/data/models/muscle_model.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_group_details_response_model.g.dart';

@JsonSerializable()
class MuscleGroupDetailsResponseModel {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'muscleGroup')
  final MuscleGroupModel? muscleGroup;

  @JsonKey(name: 'muscles')
  final List<MuscleModel>? muscles;

  MuscleGroupDetailsResponseModel({
    this.message,
    this.muscleGroup,
    this.muscles,
  });

  factory MuscleGroupDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MuscleGroupDetailsResponseModelToJson(this);

  MuscleGroupEntity? get muscleGroupEntity => muscleGroup?.toEntity();

  List<MuscleEntity> get muscleEntities =>
      muscles?.map((e) => e.toEntity()).toList() ?? [];
}
