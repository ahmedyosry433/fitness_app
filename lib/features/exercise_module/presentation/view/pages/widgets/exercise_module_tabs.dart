import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';

class ExerciseModuleTabs extends StatelessWidget {
  const ExerciseModuleTabs({super.key});

  Widget _buildTab(
    BuildContext context,
    String label,
    int index,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ExerciseModuleCubit>().loadExercises(index);
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
            style: 13.bold.copyWith(
              color: AppColors.whiteFF,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BlocBuilder<ExerciseModuleCubit, ExerciseModuleState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTab(context, tr('exercise.beginner'), 0, state.selectedDifficultyIndex == 0),
              _buildTab(context, tr('exercise.intermediate'), 1, state.selectedDifficultyIndex == 1),
              _buildTab(context, tr('exercise.advanced'), 2, state.selectedDifficultyIndex == 2),
            ],
          );
        },
      ),
    );
  }
}
