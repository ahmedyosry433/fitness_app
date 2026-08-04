import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';

abstract class LoginRepository {
  Future<Result<AuthUserEntity>> login({required LoginParams params});
}
