import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:retrofit/retrofit.dart';

part 'food_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class FoodApiClient {
  @factoryMethod
  factory FoodApiClient(Dio dio) = _FoodApiClient;

  @GET('/dummy')
  Future<void> dummy();
}
