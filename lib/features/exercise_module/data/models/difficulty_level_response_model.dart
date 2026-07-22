import 'package:fitness/features/exercise_module/data/models/difficulty_level_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'difficulty_level_response_model.g.dart';

@JsonSerializable()
class DifficultyLevelResponseModel {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<DifficultyLevelModel>? data;

  @JsonKey(name: 'levels')
  final List<DifficultyLevelModel>? levels;

  @JsonKey(name: 'difficultyLevels')
  final List<DifficultyLevelModel>? difficultyLevelsList;

  DifficultyLevelResponseModel({this.message, this.data, this.levels, this.difficultyLevelsList});

  factory DifficultyLevelResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelResponseModelToJson(this);

  List<DifficultyLevelModel> get difficultyLevels => data ?? levels ?? difficultyLevelsList ?? [];
}
