import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FoodCategoryTabsWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const FoodCategoryTabsWidget({
    super.key,
    this.categories = const ['Breakfast', 'Lunch', 'Dinner'],
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        final isSelected =
            category.toLowerCase() == selectedCategory.toLowerCase();

        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.prime : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.white : AppColors.grayD3,
                fontFamily: 'BalooThambi2',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
