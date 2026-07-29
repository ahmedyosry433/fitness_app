import 'package:fitness/features/exercise_module/data/models/exercise_model.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exercise_response_model.g.dart';

@JsonSerializable()
class ExerciseResponseModel {
  @JsonKey(name: 'message')
  final String? message;
  
  @JsonKey(name: 'totalExercises')
  final int? totalExercises;

  @JsonKey(name: 'exercises')
  final List<ExerciseModel>? exercises;

  ExerciseResponseModel({this.message, this.totalExercises, this.exercises});

  factory ExerciseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseResponseModelToJson(this);

  List<ExerciseEntity> get exerciseEntities => exercises?.map((e) => e.toEntity()).toList() ?? [];
}
