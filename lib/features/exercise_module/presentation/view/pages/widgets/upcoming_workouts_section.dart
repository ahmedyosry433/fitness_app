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

class WorkoutFilter {
  final String id;
  final String label;

  const WorkoutFilter({required this.id, required this.label});
}

class WorkoutCategoryItem {
  final String id;
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const WorkoutCategoryItem({
    required this.id,
    required this.title,
    required this.imagePath,
    this.onTap,
  });
}

class UpcomingWorkoutsSection extends StatelessWidget {
  final List<WorkoutFilter> filters;
  final List<WorkoutCategoryItem> categories;
  final String? title;
  final String selectedFilterId;
  final ValueChanged<String>? onFilterSelected;
  final VoidCallback? onSeeAllTap;
  final bool isLoading;
  final bool isLoadingCategories;

  const UpcomingWorkoutsSection({
    super.key,
    required this.filters,
    required this.categories,
    this.title,
    this.selectedFilterId = '',
    this.onFilterSelected,
    this.onSeeAllTap,
    this.isLoading = false,
    this.isLoadingCategories = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? LocaleKeys.exercise_upcoming_workouts.tr(),
              style: 16.semiBold.copyWith(
                color: AppColors.whiteFF,
                height: 1.2,
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap,
              child: Text(
                LocaleKeys.exercise_see_all.tr(),
                style: 14.regular.copyWith(
                  color: AppColors.primaryOrangeDark,
                  height: 1.2,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryOrangeDark,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 30.h,
          child: isLoading
              ? const _FilterChipsShimmer()
              : filters.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        return _WorkoutFilterChip(
                          label: filter.label,
                          isSelected: filter.id == selectedFilterId,
                          onTap: () => onFilterSelected?.call(filter.id),
                        );
                      },
                    ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 80.w,
          child: isLoading || isLoadingCategories
              ? const _CategoryCardsShimmer()
              : categories.isEmpty
                  ? Center(
                      child: Text(
                        LocaleKeys.exercise_no_exercises_found.tr(),
                        style: 12.regular.copyWith(color: AppColors.grayD3),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 16.w),
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return _WorkoutCategoryCard(
                          title: item.title,
                          imagePath: item.imagePath,
                          onTap: item.onTap,
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _WorkoutFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _WorkoutFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrangeDark
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: 12.bold.copyWith(
            color: isSelected ? AppColors.whiteFF : AppColors.grayD3,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _WorkoutCategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const _WorkoutCategoryCard({
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
        width: 80.w,
        height: 80.w,
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
              const ColoredBox(color: AppColors.whiteFF),
              if (_isNetworkImage)
                CustomCachedImage(
                  imagePath: imagePath,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorImage: AppImages.exercisesBack,
                )
              else
                Image.asset(
                  imagePath.isEmpty ? AppImages.exercisesBack : imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    AppImages.exercisesBack,
                    fit: BoxFit.cover,
                  ),
                ),
              Container(color: AppColors.black.withValues(alpha: 0.2)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 80.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
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

class _FilterChipsShimmer extends StatelessWidget {
  const _FilterChipsShimmer();

  @override
  Widget build(BuildContext context) {
    final widths = [72.w, 56.w, 48.w, 70.w, 52.w];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widths.length,
      separatorBuilder: (context, index) => SizedBox(width: 8.w),
      itemBuilder: (context, index) {
        return CustomShimmerContainer(
          width: widths[index],
          height: 30.h,
          borderRadius: 30.r,
        );
      },
    );
  }
}

class _CategoryCardsShimmer extends StatelessWidget {
  const _CategoryCardsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(width: 16.w),
      itemBuilder: (context, index) {
        return CustomShimmerContainer(
          width: 80.w,
          height: 80.w,
          borderRadius: 24.r,
        );
      },
    );
  }
}
