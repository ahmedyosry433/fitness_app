import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';

abstract class AuthRemoteDataSourceContract {
  Future<Result<AuthResponseModel>> login({required LoginParams params});

  Future<Result<AuthResponseModel>> register({required RegisterParams params});

  Future<Result<void>> forgotPassword({required ForgotPasswordParams params});
}
