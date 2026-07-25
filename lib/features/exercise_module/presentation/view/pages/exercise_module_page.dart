import 'dart:ui';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';

import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';
import 'package:fitness/config/base_state/base_state.dart';

import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'widgets/exercise_card.dart';

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

  Widget _buildTab(
    BuildContext context,
    String label,
    int index,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ExerciseModuleCubit>().processIntent(
            LoadExercisesIntent(index),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orangePrimary : AppColors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            label,
            style: 13.bold.copyWith(color: AppColors.whiteFF),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isOrangeText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border.all(
          color: isOrangeText
              ? AppColors.orangePrimary
              : AppColors.whiteFF.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: 12.semiBold.copyWith(
          color: isOrangeText ? AppColors.orangePrimary : AppColors.whiteFF,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black0C,
      body: Stack(
        children: [
          // Bottom Background Image (home_back)
          Positioned.fill(
            child: Image.asset(AppImages.homeBack, fit: BoxFit.cover),
          ),
          // Blur Bottom Section
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(color: AppColors.transparent),
              ),
            ),
          ),
          // Top Background Image
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
          // Gradient Fade to blend both images
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black0C.withOpacity(0.0),
                    AppColors.black0C.withOpacity(0.6),
                    AppColors.black0C,
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      // Back Button
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: AppColors.orangePrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: AppColors.whiteFF,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 180.h,
                      ), // Spacing to match the top area of the image

                      BlocBuilder<
                        ExerciseModuleCubit,
                        BaseState<ExerciseModuleUIModel>
                      >(
                        buildWhen: (previous, current) {
                          return previous.data?.pageTitle !=
                                  current.data?.pageTitle ||
                              previous.data?.pageDescription !=
                                  current.data?.pageDescription;
                        },
                        builder: (context, state) {
                          final data = state.data ?? const ExerciseModuleUIModel();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  data.pageTitle.isNotEmpty
                                      ? data.pageTitle
                                      : LocaleKeys.exercise_chest_exercise.tr(),
                                  style: 28.bold.copyWith(
                                    color: AppColors.whiteFF,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                data.pageDescription.isNotEmpty
                                    ? data.pageDescription
                                    : LocaleKeys.exercise_chest_exercise_desc
                                          .tr(),
                                textAlign: TextAlign.left,
                                style: 14.regular.copyWith(
                                  color: AppColors.grayCF,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      BlocBuilder<
                        ExerciseModuleCubit,
                        BaseState<ExerciseModuleUIModel>
                      >(
                        buildWhen: (previous, current) {
                          return previous.data?.exercises !=
                              current.data?.exercises;
                        },
                        builder: (context, state) {
                          final exercises = state.data?.exercises ?? [];
                          int totalMins = exercises.fold(
                            0,
                            (sum, item) => sum + (int.tryParse(item.time) ?? 0),
                          );
                          int totalCals = exercises.fold(
                            0,
                            (sum, item) =>
                                sum + (int.tryParse(item.calories) ?? 0),
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildChip(
                                '$totalMins ${LocaleKeys.exercise_min.tr()}',
                              ),
                              _buildChip(
                                '$totalCals ${LocaleKeys.exercise_cal.tr()}',
                                isOrangeText: true,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child:
                      BlocBuilder<
                        ExerciseModuleCubit,
                        BaseState<ExerciseModuleUIModel>
                      >(
                        buildWhen: (previous, current) {
                          final prevData = previous.data;
                          final currData = current.data;
                          return prevData?.difficultyLevels !=
                                  currData?.difficultyLevels ||
                              prevData?.selectedDifficultyIndex !=
                                  currData?.selectedDifficultyIndex;
                        },
                        builder: (context, state) {
                          final data = state.data ?? const ExerciseModuleUIModel();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: data.difficultyLevels.asMap().entries.map(
                              (entry) {
                                return _buildTab(
                                  context,
                                  entry.value.name,
                                  entry.key,
                                  data.selectedDifficultyIndex == entry.key,
                                );
                              },
                            ).toList(),
                          );
                        },
                      ),
                ),

                SizedBox(height: 25.h),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.black2A.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 25.h),
                            BlocBuilder<
                              ExerciseModuleCubit,
                              BaseState<ExerciseModuleUIModel>
                            >(
                              builder: (context, state) {
                                Widget buildSkeleton() {
                                  final dummyExercise = ExerciseEntity(
                                    id: '',
                                    title: LocaleKeys.exercise_skeleton_title
                                        .tr(),
                                    description: LocaleKeys
                                        .exercise_skeleton_desc
                                        .tr(),
                                    videoUrl: '',
                                    thumbnailUrl: '',
                                    time: '10',
                                    calories: '100',
                                    level: LocaleKeys.exercise_beginner.tr(),
                                  );
                                  return Expanded(
                                    child: Skeletonizer(
                                      enabled: true,
                                      effect: const ShimmerEffect(
                                        baseColor: AppColors.gray37,
                                        highlightColor: AppColors.gray5F,
                                      ),
                                      containersColor: AppColors.transparent,
                                      child: ListView.separated(
                                        padding: EdgeInsets.only(
                                          left: 20.w,
                                          right: 20.w,
                                          bottom: 20.h,
                                        ),
                                        itemBuilder: (context, index) =>
                                            ExerciseCard(
                                              exercise: dummyExercise,
                                            ),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 15.h),
                                        itemCount: 4,
                                      ),
                                    ),
                                  );
                                }

                                return state.when(
                                  initial: () => buildSkeleton(),
                                  loading: () => buildSkeleton(),
                                  error: (exception) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 50.h),
                                      child: Center(
                                        child: Text(
                                          LocaleKeys.exercise_failed_to_load.tr(
                                            args: [
                                              exception.toString().replaceAll(
                                                'Exception: ',
                                                '',
                                              ),
                                            ],
                                          ),
                                          style: 16.medium.copyWith(
                                            color: AppColors.whiteFF,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                  success: (ExerciseModuleUIModel? data) {
                                    if (data == null || data.exercises.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 50.h),
                                        child: Center(
                                          child: Text(
                                            LocaleKeys
                                                .exercise_no_exercises_found
                                                .tr(),
                                            style: 16.regular.copyWith(
                                              color: AppColors.grayCF,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.only(
                                          left: 20.w,
                                          right: 20.w,
                                          bottom: 20.h,
                                        ),
                                        itemBuilder: (context, index) {
                                          final exercise =
                                              data.exercises[index];
                                          return ExerciseCard(
                                            exercise: exercise,
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 15.h),
                                        itemCount: data.exercises.length,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
