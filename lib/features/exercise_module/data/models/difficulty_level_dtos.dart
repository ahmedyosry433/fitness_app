import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'difficulty_level_dtos.g.dart';

@JsonSerializable()
class DifficultyLevelDataDto {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'level')
  final String? level;

  DifficultyLevelDataDto({this.id, this.level});

  factory DifficultyLevelDataDto.fromJson(Map<String, dynamic> json) => _$DifficultyLevelDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DifficultyLevelDataDtoToJson(this);

  DifficultyLevelEntity toEntity() => DifficultyLevelEntity(id: id ?? '', name: level ?? 'Unknown');
}

@JsonSerializable()
class DifficultyLevelNameDto {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;

  DifficultyLevelNameDto({this.id, this.name});

  factory DifficultyLevelNameDto.fromJson(Map<String, dynamic> json) => _$DifficultyLevelNameDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DifficultyLevelNameDtoToJson(this);

  DifficultyLevelEntity toEntity() => DifficultyLevelEntity(id: id ?? '', name: name ?? 'Unknown');
}

@JsonSerializable()
class DifficultyLevelTitleDto {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'title')
  final String? title;

  DifficultyLevelTitleDto({this.id, this.title});

  factory DifficultyLevelTitleDto.fromJson(Map<String, dynamic> json) => _$DifficultyLevelTitleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DifficultyLevelTitleDtoToJson(this);

  DifficultyLevelEntity toEntity() => DifficultyLevelEntity(id: id ?? '', name: title ?? 'Unknown');
}
