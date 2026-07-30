import 'dart:ui';

import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FoodRecommendationItem {
  final String title;
  final String imageUrl;

  const FoodRecommendationItem({
    required this.title,
    required this.imageUrl,
  });
}

class FoodRecommendationHomeSection extends StatelessWidget {
  final List<FoodRecommendationItem> items;
  final VoidCallback? onSeeAllTap;

  const FoodRecommendationHomeSection({
    super.key,
    this.items = const [
      FoodRecommendationItem(
        title: 'Breakfast',
        imageUrl: 'https://www.themealdb.com/images/category/breakfast.png',
      ),
      FoodRecommendationItem(
        title: 'Lunch',
        imageUrl: 'https://www.themealdb.com/images/category/beef.png',
      ),
      FoodRecommendationItem(
        title: 'Dinner',
        imageUrl: 'https://www.themealdb.com/images/category/pasta.png',
      ),
    ],
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommendation For You',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'BalooThambi2',
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap ??
                  () {
                    context.push(Routes.foodRecommendation);
                  },
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColors.prime,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.prime,
                  fontFamily: 'BalooThambi2',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return _FoodRecommendationCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _FoodRecommendationCard extends StatelessWidget {
  final FoodRecommendationItem item;

  const _FoodRecommendationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          Routes.foodRecommendation,
          extra: item.title,
        );
      },
      child: Container(
        width: 104,
        height: 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2.5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomCachedImage(
                imagePath: item.imageUrl,
                fit: BoxFit.cover,
                radius: 20,
              ),
              Container(
                color: Colors.black.withValues(alpha: 0.2),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      color: const Color(0x80242424),
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'BalooThambi2',
                        ),
                      ),
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
