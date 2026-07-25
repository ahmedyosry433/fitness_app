import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';

abstract class FoodRemoteDataSourceContract {
  Future<Result<MealDto>> getMealDetails(String mealId);
}
