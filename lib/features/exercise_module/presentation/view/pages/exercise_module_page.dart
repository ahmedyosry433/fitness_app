import 'dart:ui';

import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/exercise_difficulty_tabs.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/exercise_header_section.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/exercise_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseModulePage extends StatelessWidget {
  final String primeMoverMuscleId;
  final String pageTitle;
  final String pageDescription;
  final String backgroundImage;

  const ExerciseModulePage({
    super.key,
    required this.primeMoverMuscleId,
    required this.pageTitle,
    required this.pageDescription,
    this.backgroundImage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black0C,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.homeBack, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(color: AppColors.transparent),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 420.h,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: backgroundImage.isNotEmpty
                  ? (backgroundImage.startsWith('http')
                      ? CustomCachedImage(
                          imagePath: backgroundImage,
                          fit: BoxFit.cover,
                          errorImage: AppImages.exercisesBack,
                        )
                      : Image.asset(
                          backgroundImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AppImages.exercisesBack,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ))
                  : Image.asset(
                      AppImages.exercisesBack,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black0C.withValues(alpha: 0.0),
                    AppColors.black0C.withValues(alpha: 0.6),
                    AppColors.black0C,
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExerciseHeaderSection(),
                SizedBox(height: 30.h),
                const ExerciseDifficultyTabs(),
                SizedBox(height: 25.h),
                const ExerciseListContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
