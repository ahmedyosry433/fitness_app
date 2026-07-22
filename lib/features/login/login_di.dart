import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/login/api/api_client/login_api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class LoginInjectableModule {
  @lazySingleton
  LoginApiClient loginApiClient(Dio dio) =>
      LoginApiClient(dio, baseUrl: AppEndPoints.baseUrl);
}
