// TODO: api FoodApiClient
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

part 'food_api_client.g.dart';

@lazySingleton
abstract class FoodApiClient {
  @factoryMethod
  factory FoodApiClient(Dio dio) = _FoodApiClient;
}
