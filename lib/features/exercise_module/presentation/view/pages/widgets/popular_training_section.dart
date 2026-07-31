import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/features/exercise_module/domain/entities/difficulty_level_entity.dart';

class PopularTrainingItem {
  final DifficultyLevelEntity level;
  final String title;
  final int taskCount;
  final String imagePath;

  const PopularTrainingItem({
    required this.level,
    required this.title,
    required this.taskCount,
    this.imagePath = '',
  });
}

class PopularTrainingSection extends StatelessWidget {
  final List<DifficultyLevelEntity> levels;
  final int selectedIndex;
  final Function(int index) onLevelSelected;
  final String? muscleName;
  final int? currentExerciseCount;
  final EdgeInsetsGeometry? padding;

  const PopularTrainingSection({
    super.key,
    required this.levels,
    required this.selectedIndex,
    required this.onLevelSelected,
    this.muscleName,
    this.currentExerciseCount,
    this.padding,
  });

  static const List<int> _defaultTaskCounts = [24, 36, 48];

  @override
  Widget build(BuildContext context) {
    if (levels.isEmpty) return const SizedBox.shrink();

    final targetMuscle = muscleName ?? LocaleKeys.exercise_chest.tr();
    final horizontalPadding = padding ?? EdgeInsets.symmetric(horizontal: 20.w);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: horizontalPadding,
          child: Text(
            LocaleKeys.exercise_popular_training.tr(),
            style: 16.semiBold.copyWith(
              color: AppColors.whiteFF,
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 176.h,
          child: ListView.separated(
            padding: horizontalPadding,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: levels.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final level = levels[index];
              final isSelected = selectedIndex == index;
              final taskCount = (isSelected && currentExerciseCount != null && currentExerciseCount! > 0)
                  ? currentExerciseCount!
                  : _defaultTaskCounts[index % _defaultTaskCounts.length];

              return PopularTrainingCard(
                levelName: level.name,
                muscleName: targetMuscle,
                taskCount: taskCount,
                isSelected: isSelected,
                onTap: () => onLevelSelected(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularTrainingCard extends StatelessWidget {
  final String levelName;
  final String muscleName;
  final int taskCount;
  final bool isSelected;
  final VoidCallback onTap;
  final String? imagePath;

  const PopularTrainingCard({
    super.key,
    required this.levelName,
    required this.muscleName,
    required this.taskCount,
    required this.isSelected,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 200.w,
        height: 176.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.orangePrimary
                : AppColors.transparent,
            width: isSelected ? 2 : 0,
          ),
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
              // Image background
              if (imagePath != null && imagePath!.isNotEmpty)
                (imagePath!.startsWith('http')
                    ? CustomCachedImage(
                        imagePath: imagePath!,
                        fit: BoxFit.cover,
                        errorImage: AppImages.exercisesBack,
                      )
                    : Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          AppImages.exercisesBack,
                          fit: BoxFit.cover,
                        ),
                      ))
              else
                Image.asset(
                  AppImages.exercisesBack,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),

              // Dark Overlay
              Container(
                color: AppColors.black.withValues(alpha: 0.5),
              ),

              // Card Title & Bottom Bar Container
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    // Title Text
                    Text(
                      'exercises that\nstrengthen your $muscleName',
                      textAlign: TextAlign.center,
                      style: 14.semiBold.copyWith(
                        color: AppColors.whiteFF,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Bottom Glassmorphic Pills
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Task Count Pill
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              color: AppColors.black22.withValues(alpha: 0.5),
                              child: Text(
                                '$taskCount tasks',
                                style: 12.regular.copyWith(
                                  color: AppColors.whiteFF,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Level Name Pill
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              color: AppColors.black22.withValues(alpha: 0.5),
                              child: Text(
                                levelName,
                                style: 12.bold.copyWith(
                                  color: AppColors.orangePrimary,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
