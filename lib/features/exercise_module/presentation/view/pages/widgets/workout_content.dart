import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/workout_widgets.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutContent extends StatelessWidget {
  const WorkoutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutCubit, WorkoutState>(
      buildWhen: (previous, current) {
        return previous.categoriesState != current.categoriesState ||
            previous.exercisesState != current.exercisesState ||
            previous.selectedCategoryIndex != current.selectedCategoryIndex;
      },
      builder: (context, state) {
        if (state.categoriesState.isError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                state.categoriesState.exception
                        ?.toString()
                        .replaceAll('Exception: ', '') ??
                    LocaleKeys.exercise_failed_to_load.tr(args: ['']),
                style: 14.regular.copyWith(color: AppColors.whiteFF),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (!state.exercisesState.isSuccess) {
          if (state.exercisesState.isError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  state.exercisesState.exception
                          ?.toString()
                          .replaceAll('Exception: ', '') ??
                      LocaleKeys.exercise_failed_to_load.tr(args: ['']),
                  style: 14.regular.copyWith(color: AppColors.whiteFF),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return const WorkoutGridShimmer();
        }

        if (state.exercises.isEmpty) {
          return Center(
            child: Text(
              LocaleKeys.exercise_no_exercises_found.tr(),
              style: 16.regular.copyWith(color: AppColors.grayCF),
            ),
          );
        }

        return WorkoutExercisesGrid(exercises: state.exercises);
      },
    );
  }
}
