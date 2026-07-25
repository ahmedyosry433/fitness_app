import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/data/datasources/food_remote_data_source_contract.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:fitness/features/food/domain/repositories/food_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FoodRepositoryContract)
class FoodRepositoryImpl implements FoodRepositoryContract {
  final FoodRemoteDataSourceContract foodRemoteDataSourceContract;

  FoodRepositoryImpl(this.foodRemoteDataSourceContract);

  @override
  Future<Result<MealDto>> getMealDetails(String mealId) async {
    return await foodRemoteDataSourceContract.getMealDetails(mealId);
  }
}