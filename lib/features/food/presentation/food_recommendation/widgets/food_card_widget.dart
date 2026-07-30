import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:flutter/material.dart';

class FoodCardWidget extends StatelessWidget {
  final MealDto meal;
  final VoidCallback? onTap;

  const FoodCardWidget({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomCachedImage(
                imagePath: meal.strMealThumb ?? '',
                fit: BoxFit.cover,
                radius: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  child: Text(
                    meal.strMeal ?? 'Pasta with chicks',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      fontFamily: 'BalooThambi2',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
