import 'package:json_annotation/json_annotation.dart';

part 'auth_common_response.g.dart';

@JsonSerializable()
class AuthCommonResponse {
  final String? status;
  final String? message;

  AuthCommonResponse({this.status, this.message});

  factory AuthCommonResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthCommonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCommonResponseToJson(this);
}
