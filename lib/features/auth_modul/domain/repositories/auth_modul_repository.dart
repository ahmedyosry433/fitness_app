import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';

abstract class AuthModulRepository {
  Future<Result<AuthCommonResponse>> forgetPassword(
    ForgetPasswordRequest request,
  );
  Future<Result<AuthCommonResponse>> verifyOtp(String email, String otp);
  Future<Result<AuthCommonResponse>> resetPassword(
    ResetPasswordRequest request,
  );
}
