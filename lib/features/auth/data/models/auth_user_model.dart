import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? token;
  final String? role;

  const AuthUserModel({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.token,
    this.role,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUserEntity toEntity({String? tokenOverride}) {
    final computedName = (name != null && name!.isNotEmpty)
        ? name!
        : '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return AuthUserEntity(
      id: id ?? '',
      name: computedName,
      email: email ?? '',
      phone: phone ?? '',
      token: tokenOverride ?? token ?? '',
    );
  }
}

@JsonSerializable()
class AuthResponseModel {
  final String? message;
  final String? token;
  final AuthUserModel? user;

  const AuthResponseModel({this.message, this.token, this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthUserEntity toEntity() =>
      user?.toEntity(tokenOverride: token) ?? AuthUserEntity.empty();
}
