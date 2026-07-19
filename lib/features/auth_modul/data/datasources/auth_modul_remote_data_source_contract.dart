import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/signup_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';

abstract class AuthModulRemoteDataSource {
  Future<AuthCommonResponse> forgetPassword(ForgetPasswordRequest request);
  Future<AuthCommonResponse> verifyOtp(String email, String otp);
  Future<AuthCommonResponse> resetPassword(ResetPasswordRequest request);
  Future<AuthCommonResponse> signUp(SignUpRequest request);
}
