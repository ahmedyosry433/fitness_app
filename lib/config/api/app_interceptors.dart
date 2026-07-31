import 'package:dio/dio.dart';
import 'package:fitness/config/api/api_keys.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/user_helper/user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'status_code.dart';

@singleton
class AppInterceptors extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage fss;
  bool _isRefreshing = false;

  AppInterceptors({required this.dio, required this.fss});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.cancelToken = getIt<CancelToken>();
    String? authToken = await fss.read(key: Apikeys.accessToken);
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    
    try {
      final prefs = getIt<SharedPreferences>();
      final localeStr = prefs.getString('locale');
      if (localeStr != null && localeStr.contains('ar')) {
        options.headers['Accept-Language'] = 'ar';
      } else {
        options.headers['Accept-Language'] = 'en';
      }
    } catch (_) {
      options.headers['Accept-Language'] = 'en';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint("err.response?.statusCode ${err.response?.statusCode}");
    
    if (err.response?.statusCode == StatusCode.expiredToken) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final String? rToken = await fss.read(key: Apikeys.refreshToken);
          if (rToken != null && rToken.isNotEmpty) {
            final refreshDio = Dio(BaseOptions(baseUrl: AppEndPoints.baseUrl));
            final response = await refreshDio.post(
              AppEndPoints.refreshToken,
              data: {'refreshToken': rToken},
            );

            if (response.statusCode == 200 || response.statusCode == StatusCode.ok) {
              final newAccessToken = response.data['token'];
              final newRefreshToken = response.data['refreshToken'];

              if (newAccessToken != null) {
                await fss.write(key: Apikeys.accessToken, value: newAccessToken);
              }
              if (newRefreshToken != null) {
                await fss.write(key: Apikeys.refreshToken, value: newRefreshToken);
              }

              // Update the original request's headers and retry
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              
              final clonedRequest = await dio.fetch(err.requestOptions);
              _isRefreshing = false;
              return handler.resolve(clonedRequest);
            }
          }
        } catch (e) {
          debugPrint("Refresh Token Error: $e");
        } finally {
          _isRefreshing = false;
        }
      }

      // If token refresh failed or token is missing, log out
      getIt.get<UserHelper>().clearUserData();
      return super.onError(err, handler);
    }
    
    super.onError(err, handler);
  }
}
