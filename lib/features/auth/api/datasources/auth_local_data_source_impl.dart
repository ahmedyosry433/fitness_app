import 'dart:convert';

import 'package:fitness/config/api/api_keys.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: AuthLocalDataSourceContract)
class AuthLocalDataSourceImpl implements AuthLocalDataSourceContract {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  static const String _userKey = 'cached_auth_user';

  const AuthLocalDataSourceImpl(this._prefs, this._secureStorage);

  @override
  Future<Result<void>> saveUser(AuthUserEntity user) async {
    try {
      await _prefs.setString(Apikeys.userId, user.id);
      await _secureStorage.write(key: Apikeys.accessToken, value: user.token);
      await _prefs.setString(
        _userKey,
        jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
        }),
      );
      return const Success();
    } catch (e) {
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<AuthUserEntity?>> getCachedUser() async {
    try {
      final raw = _prefs.getString(_userKey);
      if (raw == null) return const Success(data: null);

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final token = await _secureStorage.read(key: Apikeys.accessToken);

      return Success(
        data: AuthUserEntity(
          id: map['id'] as String? ?? '',
          name: map['name'] as String? ?? '',
          email: map['email'] as String? ?? '',
          phone: map['phone'] as String? ?? '',
          token: token ?? '',
        ),
      );
    } catch (e) {
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearUser() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.remove(Apikeys.userId);
      await _secureStorage.delete(key: Apikeys.accessToken);
      return const Success();
    } catch (e) {
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }
}
