import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/custom_cached_image.dart';
import 'package:fitness/core/shared/widgets/custom_shimmer_container.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/exercise_card.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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

  Widget _buildChip(String label, {bool isOrangeText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border.all(
          color: isOrangeText
              ? AppColors.orangePrimary
              : AppColors.whiteFF.withValues(alpha: 0.3),
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
          // Bottom Background Image
          Positioned.fill(
            child: Image.asset(AppImages.homeBack, fit: BoxFit.cover),
          ),
          // Dark Tint Layer
          Positioned.fill(
            child: Container(
              color: AppColors.black0C.withValues(alpha: 0.5),
            ),
          ),
          // Top Hero Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 420.h,
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
                          alignment: const Alignment(0, -0.5),
                        ),
                      ))
                : Image.asset(
                    AppImages.exercisesBack,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.5),
                  ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black0C.withValues(alpha: 0.0),
                    AppColors.black0C.withValues(alpha: 0.4),
                    AppColors.black0C.withValues(alpha: 0.9),
                    AppColors.black0C,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Foreground Content
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
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: AppColors.orangePrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: AppColors.whiteFF,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<ExerciseModuleCubit,
                          BaseState<ExerciseModuleUIModel>>(
                        buildWhen: (previous, current) {
                          return previous.data?.pageTitle !=
                                  current.data?.pageTitle ||
                              previous.data?.pageDescription !=
                                  current.data?.pageDescription;
                        },
                        builder: (context, state) {
                          final data =
                              state.data ?? const ExerciseModuleUIModel();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  data.pageTitle.isNotEmpty
                                      ? data.pageTitle
                                      : LocaleKeys.exercise_chest_exercise.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: AppColors.whiteFF,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                data.pageDescription.isNotEmpty
                                    ? data.pageDescription
                                    : LocaleKeys.exercise_chest_exercise_desc.tr(),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: AppColors.whiteFF.withValues(
                                        alpha: 0.8,
                                      ),
                                      height: 1.4,
                                      fontSize: 14,
                                      fontFamily: 'RobotoEnglish',
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      BlocBuilder<ExerciseModuleCubit,
                          BaseState<ExerciseModuleUIModel>>(
                        buildWhen: (previous, current) {
                          return previous.data?.exercises !=
                              current.data?.exercises;
                        },
                        builder: (context, state) {
                          final exercises = state.data?.exercises ?? [];
                          int totalMins = exercises.fold(
                            0,
                            (sum, item) =>
                                sum + (int.tryParse(item.time) ?? 0),
                          );
                          int totalCals = exercises.fold(
                            0,
                            (sum, item) =>
                                sum + (int.tryParse(item.calories) ?? 0),
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: _buildChip(
                                  '$totalMins ${LocaleKeys.exercise_min.tr()}',
                                ),
                              ),
                              Flexible(
                                child: _buildChip(
                                  '$totalCals ${LocaleKeys.exercise_cal.tr()}',
                                  isOrangeText: true,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black22.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Expanded(
                          child: BlocBuilder<ExerciseModuleCubit,
                              BaseState<ExerciseModuleUIModel>>(
                            builder: (context, state) {
                              Widget buildSkeleton() {
                                return ListView.separated(
                                  key: const Key('exercise_skeleton_list'),
                                  padding: EdgeInsets.only(
                                    left: 20.w,
                                    right: 20.w,
                                    bottom: 20.h,
                                  ),
                                  itemBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: CustomShimmerContainer(
                                      height: 60.h,
                                      width: double.infinity,
                                      borderRadius: 16.r,
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 8.h),
                                  itemCount: 4,
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
                                          LocaleKeys.exercise_no_exercises_found
                                              .tr(),
                                          style: 16.regular.copyWith(
                                            color: AppColors.grayCF,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                      bottom: 20.h,
                                    ),
                                    itemBuilder: (context, index) {
                                      final exercise = data.exercises[index];
                                      return ExerciseCard(
                                        exercise: exercise,
                                      );
                                    },
                                    separatorBuilder: (context, index) => Divider(
                                      color: AppColors.whiteFF
                                          .withValues(alpha: 0.05),
                                      height: 1,
                                      thickness: 1,
                                      indent: 12.w,
                                      endIndent: 12.w,
                                    ),
                                    itemCount: data.exercises.length,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
