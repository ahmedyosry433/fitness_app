import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class IngredientsListWidget extends StatelessWidget {
  final Map<String, String> ingredientsMap;

  const IngredientsListWidget({super.key, required this.ingredientsMap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.black22.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: ingredientsMap.length,
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.gray37,
              height: 24,
              thickness: 0.5,
            ),
            itemBuilder: (context, index) {
              final key = ingredientsMap.keys.elementAt(index);
              final value = ingredientsMap[key]!;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      key,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.orangePrimary,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
