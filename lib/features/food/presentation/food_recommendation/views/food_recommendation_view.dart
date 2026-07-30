import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/food/presentation/food_recommendation/view_model/cubit/food_recommendation_cubit.dart';
import 'package:fitness/features/food/presentation/food_recommendation/view_model/intent/food_recommendation_intent.dart';
import 'package:fitness/features/food/presentation/food_recommendation/view_model/states/food_recommendation_state.dart';
import 'package:fitness/features/food/presentation/food_recommendation/widgets/food_card_widget.dart';
import 'package:fitness/features/food/presentation/food_recommendation/widgets/food_category_tabs_widget.dart';
import 'package:fitness/features/food/presentation/food_recommendation/widgets/food_recommendation_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FoodRecommendationView extends StatefulWidget {
  final String? initialCategory;

  const FoodRecommendationView({super.key, this.initialCategory});

  @override
  State<FoodRecommendationView> createState() =>
      _FoodRecommendationViewState();
}

class _FoodRecommendationViewState extends State<FoodRecommendationView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<FoodRecommendationCubit>();
    final categoryToFetch =
        widget.initialCategory ?? cubit.state.selectedCategory;
    cubit.doIntent(SelectCategoryIntent(categoryToFetch));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.85) {
      context
          .read<FoodRecommendationCubit>()
          .doIntent(const LoadMoreMealsIntent());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authCharcoal,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_back.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xCC1A1A1A),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const FoodRecommendationHeaderWidget(),
                  const SizedBox(height: 24),
                  BlocBuilder<
                      FoodRecommendationCubit,
                      FoodRecommendationState>(
                    buildWhen: (prev, curr) =>
                        prev.selectedCategory != curr.selectedCategory,
                    builder: (context, state) {
                      return FoodCategoryTabsWidget(
                        selectedCategory: state.selectedCategory,
                        onCategorySelected: (category) {
                          context.read<FoodRecommendationCubit>().doIntent(
                                SelectCategoryIntent(category),
                              );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: BlocBuilder<
                        FoodRecommendationCubit,
                        FoodRecommendationState>(
                      builder: (context, state) {
                        return switch (state.status) {
                          FoodRecommendationStatus.initial ||
                          FoodRecommendationStatus.loading => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.prime,
                              ),
                            ),
                          FoodRecommendationStatus.error => Center(
                              child: Text(
                                state.errorMessage ?? 'An error occurred',
                                style: const TextStyle(
                                  color: AppColors.redCC,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          FoodRecommendationStatus.success =>
                            state.meals.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No meals available',
                                      style: TextStyle(
                                        color: AppColors.grayD3,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : RefreshIndicator(
                                    color: AppColors.prime,
                                    backgroundColor: AppColors.authCharcoal,
                                    onRefresh: () async {
                                      context
                                          .read<FoodRecommendationCubit>()
                                          .doIntent(
                                            const RefreshMealsIntent(),
                                          );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: GridView.builder(
                                            controller: _scrollController,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics(),
                                            ),
                                            padding: const EdgeInsets.only(
                                              bottom: 24,
                                            ),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 17,
                                              childAspectRatio: 163 / 160,
                                            ),
                                            itemCount: state.meals.length,
                                            itemBuilder: (context, index) {
                                              final meal = state.meals[index];
                                              return FoodCardWidget(
                                                meal: meal,
                                                onTap: () {
                                                  if (meal.idMeal != null) {
                                                    context.push(
                                                      Routes.detailsFood,
                                                      extra: meal.idMeal,
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        if (state.isLoadingMore)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Center(
                                              child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.prime,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                        };
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
