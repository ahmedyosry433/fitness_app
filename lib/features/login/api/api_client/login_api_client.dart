import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_client.g.dart';

@RestApi()
abstract class LoginApiClient {
  factory LoginApiClient(Dio dio, {String? baseUrl}) = _LoginApiClient;

  @POST(AppEndPoints.signIn)
  Future<AuthResponseModel> login(@Body() LoginParams params);
}
