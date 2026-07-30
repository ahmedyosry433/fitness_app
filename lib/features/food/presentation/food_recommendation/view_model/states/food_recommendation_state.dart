import 'package:equatable/equatable.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';

enum FoodRecommendationStatus { initial, loading, success, error }

class FoodRecommendationState extends Equatable {
  final FoodRecommendationStatus status;
  final String selectedCategory;
  final List<MealDto> allMeals;
  final List<MealDto> meals;
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;

  const FoodRecommendationState({
    this.status = FoodRecommendationStatus.initial,
    this.selectedCategory = 'Dinner',
    this.allMeals = const [],
    this.meals = const [],
    this.page = 1,
    this.pageSize = 6,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  FoodRecommendationState copyWith({
    FoodRecommendationStatus? status,
    String? selectedCategory,
    List<MealDto>? allMeals,
    List<MealDto>? meals,
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return FoodRecommendationState(
      status: status ?? this.status,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      allMeals: allMeals ?? this.allMeals,
      meals: meals ?? this.meals,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedCategory,
        allMeals,
        meals,
        page,
        pageSize,
        hasMore,
        isLoadingMore,
        isRefreshing,
        errorMessage,
      ];
}
