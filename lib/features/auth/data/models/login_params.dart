import 'package:json_annotation/json_annotation.dart';

part 'login_params.g.dart';

@JsonSerializable()
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    this.email = '',
    this.password = '',
  });

  factory LoginParams.fromJson(Map<String, dynamic> json) =>
      _$LoginParamsFromJson(json);

  Map<String, dynamic> toJson() => _$LoginParamsToJson(this);

  LoginParams copyWith({
    String? email,
    String? password,
  }) =>
      LoginParams(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
