import 'package:fitness/features/food/domain/use_case/get_meals_by_category_use_case.dart';
import 'package:fitness/features/food/presentation/food_recommendation/view_model/intent/food_recommendation_intent.dart';
import 'package:fitness/features/food/presentation/food_recommendation/view_model/states/food_recommendation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FoodRecommendationCubit extends Cubit<FoodRecommendationState> {
  final GetMealsByCategoryUseCase _getMealsByCategoryUseCase;

  FoodRecommendationCubit(this._getMealsByCategoryUseCase)
      : super(const FoodRecommendationState());

  void doIntent(FoodRecommendationIntent intent) {
    switch (intent) {
      case FetchMealsIntent(:final category):
        _fetchMeals(category);
      case SelectCategoryIntent(:final category):
        _selectCategory(category);
      case LoadMoreMealsIntent():
        _loadMoreMeals();
      case RefreshMealsIntent():
        _refreshMeals();
    }
  }

  void _selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category, page: 1, meals: []));
    _fetchMeals(category);
  }

  Future<void> _fetchMeals(String category) async {
    emit(
      state.copyWith(
        status: FoodRecommendationStatus.loading,
        page: 1,
        meals: [],
      ),
    );

    final result = await _getMealsByCategoryUseCase(category);

    result.when(
      success: (allMealsList) {
        final list = allMealsList ?? [];
        final pageSize = state.pageSize;
        final initialPage = list.take(pageSize).toList();
        final hasMore = list.length > pageSize;

        emit(
          state.copyWith(
            status: FoodRecommendationStatus.success,
            allMeals: list,
            meals: initialPage,
            page: 1,
            hasMore: hasMore,
            isLoadingMore: false,
            isRefreshing: false,
          ),
        );
      },
      error: (exception) {
        emit(
          state.copyWith(
            status: FoodRecommendationStatus.error,
            errorMessage: exception.toString(),
            isLoadingMore: false,
            isRefreshing: false,
          ),
        );
      },
    );
  }

  Future<void> _loadMoreMeals() async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;
    final startIndex = (nextPage - 1) * state.pageSize;
    final nextChunk =
        state.allMeals.skip(startIndex).take(state.pageSize).toList();

    final updatedMeals = [...state.meals, ...nextChunk];
    final hasMore = state.allMeals.length > updatedMeals.length;

    emit(
      state.copyWith(
        meals: updatedMeals,
        page: nextPage,
        hasMore: hasMore,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> _refreshMeals() async {
    emit(state.copyWith(isRefreshing: true));
    await _fetchMeals(state.selectedCategory);
  }
}
