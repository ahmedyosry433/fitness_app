import 'package:fitness/features/exercise_module/data/models/muscle_group_model.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscles_response_model.g.dart';

@JsonSerializable()
class MusclesResponseModel {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'musclesGroup')
  final List<MuscleGroupModel>? musclesGroup;

  MusclesResponseModel({this.message, this.musclesGroup});

  factory MusclesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MusclesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesResponseModelToJson(this);

  List<MuscleGroupEntity> get muscleGroupEntities =>
      musclesGroup?.map((e) => e.toEntity()).toList() ?? [];
}
