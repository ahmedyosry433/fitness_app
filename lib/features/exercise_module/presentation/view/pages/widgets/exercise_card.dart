import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'video_player_popup.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseEntity exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => VideoPlayerPopup(
            videoUrl: exercise.videoUrl,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.black22,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CustomCachedImage(
                imagePath: exercise.thumbnailUrl,
                width: 75.w,
                height: 75.w,
                fit: BoxFit.cover,
                errorImage: AppImages.exercisesBack,
                radius: 12.r,
              ),
            ),
            SizedBox(width: 15.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: 16.bold.copyWith(
                      color: AppColors.whiteFF,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    LocaleKeys.exercise_groups_times.tr(),
                    style: 12.regular.copyWith(color: AppColors.grayCF),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    exercise.description.isNotEmpty 
                        ? exercise.description 
                        : LocaleKeys.exercise_lorem_ipsum.tr(),
                    style: 11.regular.copyWith(
                      color: AppColors.grayA6,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Play button
            Icon(
              Icons.play_circle_fill,
              color: AppColors.orangePrimary,
              size: 36.sp,
            ),
          ],
        ),
      ),
    );
  }
}
