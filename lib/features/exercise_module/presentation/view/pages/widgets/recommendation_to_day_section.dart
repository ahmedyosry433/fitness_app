import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/core/shared/widgets/custom_shimmer_container.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendationItem {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const RecommendationItem({
    required this.title,
    required this.imagePath,
    this.onTap,
  });
}

class RecommendationToDaySection extends StatelessWidget {
  final List<RecommendationItem> items;
  final String? title;
  final bool isLoading;

  const RecommendationToDaySection({
    super.key,
    required this.items,
    this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 104.w,
          child: isLoading
              ? const _RecommendationShimmer()
              : items.isEmpty
              ? Center(
                  child: Text(
                    LocaleKeys.exercise_no_exercises_found.tr(),
                    style: 12.regular.copyWith(color: AppColors.grayD3),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => SizedBox(width: 16.w),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _RecommendationCard(
                      title: item.title,
                      imagePath: item.imagePath,
                      onTap: item.onTap,
                    );
                  },
                ),
        ),
        SizedBox(height: 15.h),
        Text(
          title ?? LocaleKeys.exercise_recommendation_to_day.tr(),
          style: 16.semiBold.copyWith(color: AppColors.whiteFF, height: 1.2),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const _RecommendationCard({
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104.w,
        height: 104.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_isNetworkImage)
                CustomCachedImage(
                  imagePath: imagePath,
                  width: 104.w,
                  height: 104.w,
                  fit: BoxFit.cover,
                  errorImage: AppImages.exercisesBack,
                )
              else
                Image.asset(
                  imagePath.isEmpty ? AppImages.exercisesBack : imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(AppImages.exercisesBack, fit: BoxFit.cover),
                ),
              Container(color: AppColors.black.withValues(alpha: 0.2)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 104.w,
                      padding: EdgeInsets.all(8.r),
                      color: AppColors.black22.withValues(alpha: 0.5),
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style: 12.regular.copyWith(
                          color: AppColors.whiteFF,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

class _RecommendationShimmer extends StatelessWidget {
  const _RecommendationShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(width: 16.w),
      itemBuilder: (context, index) {
        return CustomShimmerContainer(
          width: 104.w,
          height: 104.w,
          borderRadius: 24.r,
        );
      },
    );
  }
}
