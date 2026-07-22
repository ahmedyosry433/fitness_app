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
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';

import 'widgets/exercise_module_top_section.dart';
import 'widgets/exercise_module_tabs.dart';
import 'widgets/exercise_card.dart';

class ExerciseModulePage extends StatelessWidget {
  const ExerciseModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExerciseModuleCubit>()..init(),
      child: const _ExerciseModulePageContent(),
    );
  }
}

class _ExerciseModulePageContent extends StatelessWidget {
  const _ExerciseModulePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black0C,
      body: Stack(
        children: [
          // Full Screen Background Image
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, -110.h),
              child: Transform.scale(
                scale: 1.10,
                child: Image.asset(
                  AppImages.exercisesBack,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // Blur Bottom Section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 350.h,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Container(color: AppColors.transparent),
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
                    AppColors.black0C.withOpacity(0.0),
                    AppColors.black0C.withOpacity(0.4),
                    AppColors.black0C.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 1.0],
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
                const ExerciseModuleTopSection(),

                SizedBox(height: 30.h),

                const ExerciseModuleTabs(),

                SizedBox(height: 25.h),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ), 
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
                            SizedBox(
                              height: 25.h,
                            ), 
                            BlocBuilder<
                              ExerciseModuleCubit,
                              ExerciseModuleState
                            >(
                              builder: (context, state) {
                                if (state.status == ExerciseStatus.loading ||
                                    state.status == ExerciseStatus.initial) {
                                  final dummyExercise = ExerciseEntity(
                                    id: '',
                                    title: tr('exercise.skeleton_title'),
                                    description: tr('exercise.skeleton_desc'),
                                    videoUrl: '',
                                    thumbnailUrl: '',
                                    time: '10',
                                    calories: '100',
                                    level: 'Beginner',
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
                                } else if (state.status ==
                                    ExerciseStatus.failure) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 50.h),
                                    child: Center(
                                      child: Text(
                                        tr(
                                          'exercise.failed_to_load',
                                          args: [state.errorMessage],
                                        ),
                                        style: 16.medium.copyWith(
                                          color: AppColors.whiteFF,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } else if (state.exercises.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 50.h),
                                    child: Center(
                                      child: Text(
                                        tr('exercise.no_exercises_found'),
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
                                      final exercise = state.exercises[index];
                                      return ExerciseCard(exercise: exercise);
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 15.h),
                                    itemCount: state.exercises.length,
                                  ),
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
