import 'package:fitness/features/food/data/models/response/meal_dto.dart';

sealed class DetailsFoodState {
  const DetailsFoodState();
}

class DetailsFoodInitialState extends DetailsFoodState {
  const DetailsFoodInitialState();
}

class DetailsFoodLoadingState extends DetailsFoodState {
  const DetailsFoodLoadingState();
}

class DetailsFoodSuccessState extends DetailsFoodState {
  final MealDto meal;
  const DetailsFoodSuccessState(this.meal);
}

class DetailsFoodErrorState extends DetailsFoodState {
  final String errorMessage;
  const DetailsFoodErrorState(this.errorMessage);
}