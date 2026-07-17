import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthLocalDataSourceContract {
  Future<Result<void>> saveUser(AuthUserEntity user);

  Future<Result<AuthUserEntity?>> getCachedUser();

  Future<Result<void>> clearUser();
}
