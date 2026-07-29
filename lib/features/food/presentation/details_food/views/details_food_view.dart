import 'package:fitness/core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black0C,
      body: BlocBuilder<DetailsFoodCubit, DetailsFoodState>(
        builder: (context, state) {
          return switch (state.status) {
            DetailsFoodStatus.initial ||
            DetailsFoodStatus.loading => const Center(
              child: CircularProgressIndicator(color: AppColors.orangePrimary),
            ),
            DetailsFoodStatus.error => Center(
              child: Text(
                state.errorMessage ?? '',
                style: const TextStyle(color: AppColors.redCC),
              ),
            ),
            DetailsFoodStatus.success =>
              state.meal == null
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MealHeaderWidget(meal: state.meal!),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: IngredientsListWidget(
                              ingredientsMap: state.meal!.parsedIngredients,
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
