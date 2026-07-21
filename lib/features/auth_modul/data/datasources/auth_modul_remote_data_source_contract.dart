import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/verify_otp_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';

abstract class AuthModulRemoteDataSource {
  Future<AuthCommonResponse> forgetPassword(ForgetPasswordRequest request);
  Future<AuthCommonResponse> verifyOtp(VerifyOtpRequest request);
  Future<AuthCommonResponse> resetPassword(ResetPasswordRequest request);
}
