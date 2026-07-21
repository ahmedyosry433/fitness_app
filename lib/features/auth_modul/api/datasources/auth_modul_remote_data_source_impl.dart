import 'package:fitness/features/auth_modul/data/datasources/auth_modul_remote_data_source_contract.dart';
import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/verify_otp_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthModulRemoteDataSource)
class AuthModulRemoteDataSourceImpl implements AuthModulRemoteDataSource {
  @override
  Future<AuthCommonResponse> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    return AuthCommonResponse(
      status: "success",
      message: "Verification code sent to ${request.email}",
    );
  }

  @override
  Future<AuthCommonResponse> verifyOtp(VerifyOtpRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (request.otp == "4444") {
      return AuthCommonResponse(
        status: "success",
        message: "OTP verified successfully",
      );
    } else {
      throw Exception("Invalid verification code, please try again!");
    }
  }

  @override
  Future<AuthCommonResponse> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return AuthCommonResponse(
      status: "success",
      message: "Password has been reset successfully",
    );
  }
}
