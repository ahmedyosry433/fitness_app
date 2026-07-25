import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_model.g.dart';

@JsonSerializable()
class MuscleModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'image')
  final String? image;

  MuscleModel({this.id, this.name, this.image});

  factory MuscleModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleModelFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleModelToJson(this);

  MuscleEntity toEntity() => MuscleEntity(
        id: id ?? '',
        name: (name ?? '').trim(),
        imageUrl: image ?? '',
      );
}
