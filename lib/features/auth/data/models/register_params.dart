import 'package:json_annotation/json_annotation.dart';

part 'register_params.g.dart';

@JsonSerializable()
class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  @JsonKey(name: 'rePassword')
  final String rePassword;
  @JsonKey(includeIfNull: false)
  final String? phone;
  final String gender;
  final num height;
  final num weight;
  final num age;
  final String goal;
  final String activityLevel;

  const RegisterParams({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.rePassword = '',
    this.phone,
    this.gender = 'male',
    this.height = 170,
    this.weight = 70,
    this.age = 25,
    this.goal = 'Gain weight',
    this.activityLevel = 'level1',
  });

  factory RegisterParams.fromJson(Map<String, dynamic> json) =>
      _$RegisterParamsFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterParamsToJson(this);

  RegisterParams copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? rePassword,
    String? phone,
    String? gender,
    num? height,
    num? weight,
    num? age,
    String? goal,
    String? activityLevel,
  }) => RegisterParams(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    password: password ?? this.password,
    rePassword: rePassword ?? this.rePassword,
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    age: age ?? this.age,
    goal: goal ?? this.goal,
    activityLevel: activityLevel ?? this.activityLevel,
  );
}
