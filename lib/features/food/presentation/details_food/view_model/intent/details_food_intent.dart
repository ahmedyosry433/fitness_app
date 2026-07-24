sealed class DetailsFoodIntent {
  const DetailsFoodIntent();
}

class FetchMealDetailsIntent extends DetailsFoodIntent {
  final String mealId;
  const FetchMealDetailsIntent(this.mealId);
}