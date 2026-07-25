import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/api/api_client/food_api_client.dart';
import 'package:fitness/features/food/data/datasources/food_remote_data_source_contract.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FoodRemoteDataSourceContract)
class FoodRemoteDataSourceImpl implements FoodRemoteDataSourceContract {
  final FoodApiClient _foodApiClient;

  FoodRemoteDataSourceImpl(this._foodApiClient);

  @override
  Future<Result<MealDto>> getMealDetails(String mealId) async {
    try {
      final response = await _foodApiClient.getMealDetails(mealId);
      final meal = response.meals?.firstOrNull;
      if (meal != null) {
        return Success(data: meal);
      } else {
        return Error(exception: Exception('No meal found'));
      }
    } catch (e) {
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }
}
