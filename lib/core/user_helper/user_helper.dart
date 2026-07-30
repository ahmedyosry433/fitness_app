import 'dart:convert';

import 'package:fitness/config/api/api_keys.dart';
import 'package:fitness/core/routes/app_router.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class UserHelper {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _fss;
  UserHelper(this._prefs, this._fss);

  Future<bool> isLogin() async {
    final userId = _prefs.getString(Apikeys.userId);
    final token = await _fss.read(key: Apikeys.accessToken);
    return userId != null &&
        userId.isNotEmpty &&
        token != null &&
        token.isNotEmpty;
  }

  Future<String?> getUserName() async {
    final raw = _prefs.getString('cached_auth_user');
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final name = map['name'] as String?;
        if (name != null && name.isNotEmpty) return name;
      } catch (_) {}
    }
    return null;
  }

  Future<String?> getUserPhoto() async {
    final raw = _prefs.getString('cached_auth_user');
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final photo = map['photo'] as String?;
        if (photo != null && photo.isNotEmpty) return photo;
      } catch (_) {}
    }
    return null;
  }

  /// Returns all non-sensitive cached user data as a map for AI prompt context.
  /// Keys: name, email, phone. Returns empty map if nothing is cached.
  Future<Map<String, String>> getUserProfileContext() async {
    final raw = _prefs.getString('cached_auth_user');
    if (raw == null) return const {};

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, String>{};

      final name = map['name'] as String?;
      if (name != null && name.isNotEmpty) result['name'] = name;

      final email = map['email'] as String?;
      if (email != null && email.isNotEmpty) result['email'] = email;

      final phone = map['phone'] as String?;
      if (phone != null && phone.isNotEmpty) result['phone'] = phone;

      return result;
    } catch (_) {
      return const {};
    }
  }

  Future<void> clearUserData() async {
    await _prefs.clear();
    await _fss.deleteAll();
    await DefaultCacheManager().emptyCache();
    router.go(Routes.login);
  }
}
