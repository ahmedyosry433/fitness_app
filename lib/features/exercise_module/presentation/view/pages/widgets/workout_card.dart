import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/video_player_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutCard extends StatelessWidget {
  final ExerciseEntity exercise;

  const WorkoutCard({super.key, required this.exercise});

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomCachedImage(
                imagePath: exercise.thumbnailUrl,
                fit: BoxFit.cover,
                errorImage: AppImages.exercisesBack,
                radius: 20.r,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.black.withValues(alpha: 0.15),
                      AppColors.black.withValues(alpha: 0.65),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.whiteFF.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.whiteFF,
                  size: 26.sp,
                ),
              ),
            ),
            Positioned(
              left: 12.w,
              right: 12.w,
              bottom: 14.h,
              child: Text(
                exercise.title,
                style: 14.bold.copyWith(
                  color: AppColors.whiteFF,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
