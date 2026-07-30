import 'package:dio/dio.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/food/data/models/response/category_dto.dart';
import 'package:fitness/features/food/data/models/response/meal_details_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';


part 'food_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: AppEndPoints.baseUrlFood)
abstract class FoodApiClient {
  @factoryMethod
  factory FoodApiClient(Dio dio) = _FoodApiClient;
  @GET(AppEndPoints.mealDetailsEndpoint)
  Future<MealDetailsResponse> getMealDetails(@Query('i') String mealId);

  @GET('/filter.php')
  Future<MealDetailsResponse> getMealsByCategory(@Query('c') String category);

  @GET('/categories.php')
  Future<CategoryResponse> getCategories();
}
