import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';

abstract class AuthRepository {
  Future<Result<AuthUserEntity>> login({required LoginParams params});

  Future<Result<AuthUserEntity>> register({required RegisterParams params});

  Future<Result<AuthUserEntity>> socialLogin({
    required AuthSocialProvider provider,
  });

  Future<Result<void>> forgotPassword({required ForgotPasswordParams params});

  Future<Result<void>> logout();
}

