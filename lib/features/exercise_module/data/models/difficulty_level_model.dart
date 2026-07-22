import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'difficulty_level_model.g.dart';

@JsonSerializable()
class DifficultyLevelModel extends DifficultyLevelEntity {
  const DifficultyLevelModel({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  factory DifficultyLevelModel.fromJson(Map<String, dynamic> json) {
    return DifficultyLevelModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['level'] as String? ?? json['name'] as String? ?? json['title'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'level': name,
    };
  }
}
