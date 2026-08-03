import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/exercise_card.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExerciseListContent extends StatelessWidget {
  const ExerciseListContent({super.key});

  Widget _buildSkeleton() {
    final dummyExercise = ExerciseEntity(
      id: '',
      title: LocaleKeys.exercise_skeleton_title.tr(),
      description: LocaleKeys.exercise_skeleton_desc.tr(),
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
          itemBuilder: (context, index) => ExerciseCard(
            exercise: dummyExercise,
          ),
          separatorBuilder: (context, index) => SizedBox(height: 15.h),
          itemCount: 4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              color: AppColors.black2A.withValues(alpha: 0.5),
            ),
            child: Column(
              children: [
                SizedBox(height: 25.h),
                BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleUIModel>>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => _buildSkeleton(),
                      loading: () => _buildSkeleton(),
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
                                LocaleKeys.exercise_no_exercises_found.tr(),
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
                              final exercise = data.exercises[index];
                              return ExerciseCard(exercise: exercise);
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
    );
  }
}
