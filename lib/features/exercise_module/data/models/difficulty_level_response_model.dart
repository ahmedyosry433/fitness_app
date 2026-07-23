import 'package:fitness/features/exercise_module/data/models/difficulty_level_dtos.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'difficulty_level_response_model.g.dart';

@JsonSerializable()
class DifficultyLevelResponseModel {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<DifficultyLevelDataDto>? data;

  @JsonKey(name: 'levels')
  final List<DifficultyLevelNameDto>? levels;

  @JsonKey(name: 'difficultyLevels')
  final List<DifficultyLevelTitleDto>? difficultyLevelsList;

  DifficultyLevelResponseModel({this.message, this.data, this.levels, this.difficultyLevelsList});

  factory DifficultyLevelResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelResponseModelToJson(this);

  List<DifficultyLevelEntity> get difficultyLevels {
    if (data != null && data!.isNotEmpty) return data!.map((e) => e.toEntity()).toList();
    if (levels != null && levels!.isNotEmpty) return levels!.map((e) => e.toEntity()).toList();
    if (difficultyLevelsList != null && difficultyLevelsList!.isNotEmpty) return difficultyLevelsList!.map((e) => e.toEntity()).toList();
    return [];
  }
}
