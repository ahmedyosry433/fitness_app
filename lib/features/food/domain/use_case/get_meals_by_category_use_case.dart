import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:fitness/features/food/domain/repositories/food_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMealsByCategoryUseCase {
  final FoodRepositoryContract _repository;

  GetMealsByCategoryUseCase(this._repository);

  Future<Result<List<MealDto>>> call(String category) {
    return _repository.getMealsByCategory(category);
  }
}
