import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:retrofit/retrofit.dart';

part 'food_api_client.g.dart';

class FoodApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = 'https://www.themealdb.com/api/json/v1/1';
    super.onRequest(options, handler);
  }
}

@lazySingleton
@RestApi()
abstract class FoodApiClient {
  @factoryMethod
  factory FoodApiClient(Dio dio) {
    final foodDio = Dio(dio.options);
    foodDio.interceptors.addAll(dio.interceptors);
    foodDio.interceptors.add(FoodApiInterceptor());
    
    return _FoodApiClient(foodDio);
  }

  @GET('/dummy')
  Future<void> dummy();
}
