import 'package:equatable/equatable.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';

enum DetailsFoodStatus { initial, loading, success, error }

class DetailsFoodState extends Equatable {
  final DetailsFoodStatus status;
  final MealDto? meal;
  final String? errorMessage;

  const DetailsFoodState({
    this.status = DetailsFoodStatus.initial,
    this.meal,
    this.errorMessage,
  });

  DetailsFoodState copyWith({
    DetailsFoodStatus? status,
    MealDto? meal,
    String? errorMessage,
  }) {
    return DetailsFoodState(
      status: status ?? this.status,
      meal: meal ?? this.meal,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, meal, errorMessage];
}
