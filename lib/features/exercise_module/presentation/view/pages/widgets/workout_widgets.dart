import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int index;

  const WorkoutCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<WorkoutCubit>().doIntent(
              LoadWorkoutCategoryEvent(index),
            );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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

class WorkoutMusclesGrid extends StatelessWidget {
  final List<MuscleEntity> muscles;

  const WorkoutMusclesGrid({super.key, required this.muscles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        bottom: 120.h,
      ),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 17.w,
        mainAxisSpacing: 17.h,
        childAspectRatio: 163 / 160,
      ),
      itemCount: muscles.length,
      itemBuilder: (context, index) {
        return WorkoutMuscleCard(muscle: muscles[index]);
      },
    );
  }
}

class WorkoutMuscleCard extends StatelessWidget {
  final MuscleEntity muscle;

  const WorkoutMuscleCard({super.key, required this.muscle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.exercise,
          extra: {
            'primeMoverMuscleId': muscle.id,
            'pageTitle': muscle.name,
            'backgroundImage': muscle.imageUrl,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomCachedImage(
                imagePath: muscle.imageUrl,
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
            Positioned(
              left: 12.w,
              right: 12.w,
              bottom: 14.h,
              child: Text(
                muscle.name,
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

class WorkoutGridShimmer extends StatelessWidget {
  const WorkoutGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 17.w,
        mainAxisSpacing: 17.h,
        childAspectRatio: 163 / 160,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Shimmer.fromColors(
            baseColor: AppColors.black22.withValues(alpha: 0.55),
            highlightColor: AppColors.gray5F.withValues(alpha: 0.35),
            period: const Duration(milliseconds: 1400),
            child: ColoredBox(
              color: AppColors.black22.withValues(alpha: 0.55),
            ),
          ),
        );
      },
    );
  }
}
