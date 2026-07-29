import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  @POST(AppEndPoints.signIn)
  Future<AuthResponseModel> login(@Body() LoginParams params);

  @POST(AppEndPoints.signUp)
  Future<AuthResponseModel> register(@Body() RegisterParams params);

  @POST(AppEndPoints.forgotPassword)
  Future<void> forgotPassword(@Body() ForgotPasswordParams params);
}
