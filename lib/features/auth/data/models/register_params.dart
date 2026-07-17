import 'package:json_annotation/json_annotation.dart';

part 'register_params.g.dart';

@JsonSerializable()
class RegisterParams {
  final String name;
  final String email;
  final String password;
  @JsonKey(name: 'rePassword')
  final String rePassword;
  final String phone;

  const RegisterParams({
    this.name = '',
    this.email = '',
    this.password = '',
    this.rePassword = '',
    this.phone = '',
  });

  factory RegisterParams.fromJson(Map<String, dynamic> json) =>
      _$RegisterParamsFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterParamsToJson(this);

  RegisterParams copyWith({
    String? name,
    String? email,
    String? password,
    String? rePassword,
    String? phone,
  }) =>
      RegisterParams(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        rePassword: rePassword ?? this.rePassword,
        phone: phone ?? this.phone,
      );
}
