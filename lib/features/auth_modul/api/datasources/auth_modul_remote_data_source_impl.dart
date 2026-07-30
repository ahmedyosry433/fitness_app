import 'package:fitness/features/auth_modul/api/api_client/auth_modul_api_client.dart';
import 'package:fitness/features/auth_modul/data/datasources/auth_modul_remote_data_source_contract.dart';
import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/verify_otp_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';

// @Injectable(as: AuthModulRemoteDataSource)
class AuthModulRemoteDataSourceImpl implements AuthModulRemoteDataSource {
  final AuthModulApiClient _apiClient;

  AuthModulRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthCommonResponse> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    return await _apiClient.forgetPassword(request);
  }

  @override
  Future<AuthCommonResponse> verifyOtp(VerifyOtpRequest request) async {
    return await _apiClient.verifyOtp(request);
  }

  @override
  Future<AuthCommonResponse> resetPassword(ResetPasswordRequest request) async {
    return await _apiClient.resetPassword(request);
  }
}
