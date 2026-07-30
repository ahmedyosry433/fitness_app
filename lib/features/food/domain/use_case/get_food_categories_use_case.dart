import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/data/models/response/category_dto.dart';
import 'package:fitness/features/food/domain/repositories/food_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFoodCategoriesUseCase {
  final FoodRepositoryContract _repository;

  GetFoodCategoriesUseCase(this._repository);

  Future<Result<List<CategoryDto>>> call() {
    return _repository.getCategories();
  }
}
