import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/auth/api/api_client/auth_api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthInjectableModule {
  @lazySingleton
  AuthApiClient authApiClient(Dio dio) =>
      AuthApiClient(dio, baseUrl: AppEndPoints.baseUrl);
}
