import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_group_model.g.dart';

@JsonSerializable()
class MuscleGroupModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  MuscleGroupModel({this.id, this.name});

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupModelToJson(this);

  MuscleGroupEntity toEntity() => MuscleGroupEntity(
        id: id ?? '',
        name: (name ?? '').trim(),
      );
}
