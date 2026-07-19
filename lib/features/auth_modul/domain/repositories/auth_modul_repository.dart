import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/signup_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';

abstract class AuthModulRepository {
  Future<Result<AuthCommonResponse>> forgetPassword(
    ForgetPasswordRequest request,
  );
  Future<Result<AuthCommonResponse>> verifyOtp(String email, String otp);
  Future<Result<AuthCommonResponse>> resetPassword(
    ResetPasswordRequest request,
  );
  Future<Result<AuthCommonResponse>> signUp(SignUpRequest request);
  Future<Result<SocialAccountModel>> socialSignIn(
    AuthSocialProvider provider,
  );
}

