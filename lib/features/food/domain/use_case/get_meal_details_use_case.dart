import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:fitness/features/food/domain/repositories/food_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealDetailsUseCase {
  final FoodRepositoryContract _repository;
  GetMealDetailsUseCase(this._repository);

  Future<Result<MealDto>> call(String mealId) {
    return _repository.getMealDetails(mealId);
  }
}
