import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/cubit/details_food_cubit.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/intent/details_food_intent.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/states/details_food_state.dart';
import 'package:fitness/features/food/presentation/details_food/widgets/ingredients_list_widget.dart';
import 'package:fitness/features/food/presentation/details_food/widgets/meal_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsFoodView extends StatefulWidget {
  final String mealId;

  const DetailsFoodView({super.key, required this.mealId});

  @override
  State<DetailsFoodView> createState() => _DetailsFoodViewState();
}

class _DetailsFoodViewState extends State<DetailsFoodView> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsFoodCubit>().doIntent(
      FetchMealDetailsIntent(widget.mealId),
    );
  }

  Map<String, String> _extractIngredients(MealDto meal) {
    final Map<String, String> map = {};
    final ingredients = [
      meal.strIngredient1,
      meal.strIngredient2,
      meal.strIngredient3,
      meal.strIngredient4,
      meal.strIngredient5,
      meal.strIngredient6,
      meal.strIngredient7,
      meal.strIngredient8,
      meal.strIngredient9,
      meal.strIngredient10,
      meal.strIngredient11,
      meal.strIngredient12,
      meal.strIngredient13,
      meal.strIngredient14,
      meal.strIngredient15,
      meal.strIngredient16,
      meal.strIngredient17,
      meal.strIngredient18,
      meal.strIngredient19,
      meal.strIngredient20,
    ];
    final measures = [
      meal.strMeasure1,
      meal.strMeasure2,
      meal.strMeasure3,
      meal.strMeasure4,
      meal.strMeasure5,
      meal.strMeasure6,
      meal.strMeasure7,
      meal.strMeasure8,
      meal.strMeasure9,
      meal.strMeasure10,
      meal.strMeasure11,
      meal.strMeasure12,
      meal.strMeasure13,
      meal.strMeasure14,
      meal.strMeasure15,
      meal.strMeasure16,
      meal.strMeasure17,
      meal.strMeasure18,
      meal.strMeasure19,
      meal.strMeasure20,
    ];

    for (int i = 0; i < ingredients.length; i++) {
      final name = ingredients[i];
      final measure = measures[i];
      if (name != null && name.trim().isNotEmpty) {
        map[name.trim()] = (measure != null && measure.trim().isNotEmpty)
            ? measure.trim()
            : '-';
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black0C,
      body: BlocBuilder<DetailsFoodCubit, DetailsFoodState>(
        builder: (context, state) {
          return switch (state) {
            DetailsFoodLoadingState() ||
            DetailsFoodInitialState() => const Center(
              child: CircularProgressIndicator(color: AppColors.orangePrimary),
            ),
            DetailsFoodErrorState(:final errorMessage) => Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: AppColors.redCC),
              ),
            ),
            DetailsFoodSuccessState(:final meal) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MealHeaderWidget(meal: meal),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: IngredientsListWidget(
                      ingredientsMap: _extractIngredients(meal),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
