import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseModuleChips extends StatelessWidget {
  const ExerciseModuleChips({super.key});

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
    return BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleUIModel>>(
      buildWhen: (previous, current) {
        return previous.data?.exercises != current.data?.exercises;
      },
      builder: (context, state) {
        final exercises = state.data?.exercises ?? [];
        int totalMins = exercises.fold(
          0,
          (sum, item) => sum + (int.tryParse(item.time) ?? 0),
        );
        int totalCals = exercises.fold(
          0,
          (sum, item) => sum + (int.tryParse(item.calories) ?? 0),
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
    );
  }
}

class ExerciseModuleTabs extends StatelessWidget {
  const ExerciseModuleTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleUIModel>>(
      buildWhen: (previous, current) {
        final prevData = previous.data;
        final currData = current.data;
        return prevData?.difficultyLevels != currData?.difficultyLevels ||
            prevData?.selectedDifficultyIndex != currData?.selectedDifficultyIndex;
      },
      builder: (context, state) {
        final data = state.data ?? const ExerciseModuleUIModel();
        final levels = data.difficultyLevels;
        if (levels.isEmpty) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(levels.length, (index) {
            final level = levels[index];
            final isSelected = data.selectedDifficultyIndex == index;
            return GestureDetector(
              onTap: () {
                context.read<ExerciseModuleCubit>().processIntent(
                      LoadExercisesIntent(index),
                    );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.orangePrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  level.name.toLowerCase() == 'novice' ? 'Advanced' : level.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isSelected
                            ? AppColors.whiteFF
                            : AppColors.whiteFF.withValues(alpha: 0.8),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
