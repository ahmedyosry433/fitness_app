import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/food/domain/entities/ingredient_entity.dart';
import 'package:flutter/material.dart';

class IngredientsListWidget extends StatelessWidget {
  final List<IngredientEntity> ingredientsMap;

  const IngredientsListWidget({super.key, required this.ingredientsMap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.details_ingredients.tr(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                itemCount: ingredientsMap.length,
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.gray37,
                  height: 24,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  final item = ingredientsMap[index];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Text(
                        item.measure,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.orangePrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
