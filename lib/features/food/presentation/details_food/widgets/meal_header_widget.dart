import 'package:fitness/core/helper/extensions/widgets_extensions.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:fitness/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MealHeaderWidget extends StatelessWidget {
  final MealDto meal;

  const MealHeaderWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        // 1. Image Background with Dark Gradient
        Container(
          height: mediaQuery.size.height * 0.50,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(meal.strMealThumb ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black0C..withValues(alpha: 0.2),
                  AppColors.black0C.withValues(alpha: 0.5),
                  AppColors.black0C,
                ],
                stops: const [0.0, 0.65, 1.0],
              ),
            ),
          ),
        ),

        // 2. Back Button
        Positioned(
          top: mediaQuery.padding.top + 10,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(Assets.icons.vector1),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.strMeal ?? '',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                meal.strInstructions ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.white,
                  height: 1.4,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Nutrition Circles Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NutritionBadge(
                    value: '${meal.calculatedCalories} K',
                    label: 'Energy',
                  ),
                  _NutritionBadge(
                    value: '${meal.calculatedProtein} G',
                    label: 'Protein',
                  ),
                  _NutritionBadge(
                    value: '${meal.calculatedCarbs} G',
                    label: 'Carbs',
                  ),
                  _NutritionBadge(
                    value: '${meal.calculatedFat} G',
                    label: 'Fat',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NutritionBadge extends StatelessWidget {
  final String value;
  final String label;

  const _NutritionBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gray37, width: 1.2),
        color: AppColors.black0C.withValues(alpha: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
