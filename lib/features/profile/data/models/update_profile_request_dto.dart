import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request_dto.g.dart';

@JsonSerializable()
class UpdateProfileRequestDto {
  final String name;
  final String? email;
  final int? weight;
  final String? goal;
  final String? activityLevel;

  UpdateProfileRequestDto({
    required this.name,
    this.email,
    this.weight,
    this.goal,
    this.activityLevel,
  });

  factory UpdateProfileRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}
