import 'dart:ui';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';

import 'widgets/exercise_module_header.dart';
import 'widgets/exercise_module_info_bar.dart';
import 'widgets/exercise_module_list.dart';

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
      body: Column(
        children: [
          SizedBox(
            height: 344.h,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: backgroundImage.isNotEmpty
                      ? (backgroundImage.startsWith('http')
                            ? CustomCachedImage(
                                imagePath: backgroundImage,
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, 0.2),
                                errorImage: AppImages.exercisesBack,
                              )
                            : Image.asset(
                                backgroundImage,
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, 0.2),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                      AppImages.exercisesBack,
                                      fit: BoxFit.cover,
                                      alignment: const Alignment(0, 0.2),
                                    ),
                              ))
                      : Image.asset(
                          AppImages.exercisesBack,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, 0.2),
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
                          AppColors.black0C.withValues(alpha: 0.3),
                          AppColors.black0C.withValues(alpha: 0.5),
                          AppColors.black0C.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ExerciseModuleHeader(),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const ExerciseModuleChips(),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 48.h,
            width: double.infinity,
            color: AppColors.black22.withValues(
              alpha: 0.6,
            ), // Dark background for tabs matching design
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const ExerciseModuleTabs(),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.black22.withValues(
                alpha: 0.6,
              ), // Solid dark list background
              child: const ExerciseModuleList(),
            ),
          ),
        ],
      ),
    );
  }
}
