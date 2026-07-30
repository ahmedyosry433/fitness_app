sealed class FoodRecommendationIntent {
  const FoodRecommendationIntent();
}

class FetchMealsIntent extends FoodRecommendationIntent {
  final String category;
  const FetchMealsIntent(this.category);
}

class SelectCategoryIntent extends FoodRecommendationIntent {
  final String category;
  const SelectCategoryIntent(this.category);
}

class LoadMoreMealsIntent extends FoodRecommendationIntent {
  const LoadMoreMealsIntent();
}

class RefreshMealsIntent extends FoodRecommendationIntent {
  const RefreshMealsIntent();
}
