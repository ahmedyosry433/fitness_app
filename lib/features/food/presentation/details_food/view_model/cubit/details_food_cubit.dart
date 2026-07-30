import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/food/domain/use_case/get_meal_details_use_case.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/intent/details_food_intent.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/states/details_food_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DetailsFoodCubit extends Cubit<DetailsFoodState> {
  final GetMealDetailsUseCase _getMealDetailsUseCase;

  DetailsFoodCubit(this._getMealDetailsUseCase)
      : super(const DetailsFoodState());

  void doIntent(DetailsFoodIntent intent) {
    switch (intent) {
      case FetchMealDetailsIntent(:final mealId):
        _fetchMealDetails(mealId);
    }
  }

  Future<void> _fetchMealDetails(String mealId) async {
    emit(state.copyWith(status: DetailsFoodStatus.loading));

    final result = await _getMealDetailsUseCase(mealId);

    result.when(
      success: (data) {
        if (data != null) {
          emit(
            state.copyWith(
              status: DetailsFoodStatus.success,
              meal: data,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: DetailsFoodStatus.error,
              errorMessage: LocaleKeys.details_no_meal_details_found.tr(),
            ),
          );
        }
      },
      error: (exception) {
        emit(
          state.copyWith(
            status: DetailsFoodStatus.error,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  }
}