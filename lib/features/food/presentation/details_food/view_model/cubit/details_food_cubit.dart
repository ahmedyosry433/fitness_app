import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness/features/food/domain/use_case/get_meal_details_use_case.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/intent/details_food_intent.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/states/details_food_state.dart';

@injectable
class DetailsFoodCubit extends Cubit<DetailsFoodState> {
  final GetMealDetailsUseCase _getMealDetailsUseCase;

  DetailsFoodCubit(this._getMealDetailsUseCase)
      : super(const DetailsFoodInitialState());

  void doIntent(DetailsFoodIntent intent) {
    switch (intent) {
      case FetchMealDetailsIntent(:final mealId):
        _fetchMealDetails(mealId);
    }
  }

  Future<void> _fetchMealDetails(String mealId) async {
    emit(const DetailsFoodLoadingState());

    final result = await _getMealDetailsUseCase(mealId);

    result.when(
      success: (data) {
        if (data != null) {
          emit(DetailsFoodSuccessState(data));
        } else {
          emit(const DetailsFoodErrorState('No meal details found'));
        }
      },
      error: (exception) {
        emit(DetailsFoodErrorState(exception.toString()));
      },
    );
  }
}