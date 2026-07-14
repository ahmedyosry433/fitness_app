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
  bool isLogin() => _prefs.getString(Apikeys.userId) != null;
  Future<void> clearUserData() async {
    _prefs.clear();
    await _fss.deleteAll();
    await DefaultCacheManager().emptyCache();
    router.go(Routes.login);
  }
}
