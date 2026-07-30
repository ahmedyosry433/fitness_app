import 'package:dio/dio.dart';
import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/verify_otp_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_modul_api_client.g.dart';

@RestApi()
@injectable
abstract class AuthModulApiClient {
  @factoryMethod
  factory AuthModulApiClient(Dio dio) = _AuthModulApiClient;

  @POST('/auth/forget-password')
  Future<AuthCommonResponse> forgetPassword(
    @Body() ForgetPasswordRequest request,
  );

  @POST('/auth/verify-otp')
  Future<AuthCommonResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST('/auth/reset-password')
  Future<AuthCommonResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );
}
