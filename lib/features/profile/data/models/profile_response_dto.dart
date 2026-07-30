import 'package:json_annotation/json_annotation.dart';

part 'profile_response_dto.g.dart';

@JsonSerializable()
class ProfileResponseDto {
  final UserDto? data;
  final String? message;

  ProfileResponseDto({this.data, this.message});

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseDtoToJson(this);
}

@JsonSerializable()
class UserDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  final String? photo;

  UserDto({this.id, this.name, this.email, this.photo});

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
