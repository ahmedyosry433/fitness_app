import 'package:fitness/features/exercise_module/data/models/muscle_model.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'random_muscles_response_model.g.dart';

@JsonSerializable()
class RandomMusclesResponseModel {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'totalMuscles')
  final int? totalMuscles;

  @JsonKey(name: 'muscles')
  final List<MuscleModel>? muscles;

  RandomMusclesResponseModel({
    this.message,
    this.totalMuscles,
    this.muscles,
  });

  factory RandomMusclesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RandomMusclesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RandomMusclesResponseModelToJson(this);

  List<MuscleEntity> get muscleEntities =>
      muscles?.map((e) => e.toEntity()).toList() ?? [];
}
