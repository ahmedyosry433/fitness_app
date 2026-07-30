import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/error/failures.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/food/api/api_client/food_api_client.dart';
import 'package:fitness/features/food/data/datasources/food_remote_data_source_contract.dart';
import 'package:fitness/features/food/data/models/response/category_dto.dart';
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
        return Error(
          exception: Exception(LocaleKeys.details_no_meal_found.tr()),
        );
      }
    } on DioException catch (e) {
      return Error(exception: ServerFailure.fromDioException(dioException: e));
    } catch (e) {
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<MealDto>>> getMealsByCategory(String category) async {
    try {
      final queryCategory = switch (category.trim().toLowerCase()) {
        'lunch' => 'Beef',
        'dinner' => 'Pasta',
        _ => 'Breakfast',
      };
      final response = await _foodApiClient.getMealsByCategory(queryCategory);
      final meals = response.meals;
      if (meals != null && meals.isNotEmpty) {
        return Success(data: meals);
      } else {
        return Success(data: _getDummyMeals());
      }
    } catch (_) {
      return Success(data: _getDummyMeals());
    }
  }

  List<MealDto> _getDummyMeals() {
    return [
      MealDto(
        idMeal: '52959',
        strMeal: 'Pasta With Chicks',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg',
      ),
      MealDto(
        idMeal: '52819',
        strMeal: 'Cajun spiced chicken tacos',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg',
      ),
      MealDto(
        idMeal: '52935',
        strMeal: 'Steak Diane',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/vussxq1511882648.jpg',
      ),
      MealDto(
        idMeal: '52934',
        strMeal: 'Chicken Alfredo Primavera',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/syqypv1486981727.jpg',
      ),
      MealDto(
        idMeal: '52940',
        strMeal: 'Chicken Handi',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/wywuvq1511816043.jpg',
      ),
      MealDto(
        idMeal: '52956',
        strMeal: 'Chicken Congee',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/1529446352.jpg',
      ),
    ];
  }

  @override
  Future<Result<List<CategoryDto>>> getCategories() async {
    try {
      final response = await _foodApiClient.getCategories();
      final categories = response.categories;
      if (categories != null && categories.isNotEmpty) {
        return Success(data: categories);
      } else {
        return Success(data: _getDummyCategories());
      }
    } catch (_) {
      return Success(data: _getDummyCategories());
    }
  }

  List<CategoryDto> _getDummyCategories() {
    return [
      CategoryDto(
        idCategory: '13',
        strCategory: 'Breakfast',
        strCategoryThumb:
            'https://www.themealdb.com/images/category/breakfast.png',
      ),
      CategoryDto(
        idCategory: '1',
        strCategory: 'Lunch',
        strCategoryThumb:
            'https://www.themealdb.com/images/category/beef.png',
      ),
      CategoryDto(
        idCategory: '6',
        strCategory: 'Dinner',
        strCategoryThumb:
            'https://www.themealdb.com/images/category/pasta.png',
      ),
    ];
  }
}
