import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';

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
          context.read<ExerciseModuleCubit>().processIntent(LoadExercisesIntent(index));
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
      child: BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleData>>(
        builder: (context, state) {
          final data = state.data ?? const ExerciseModuleData();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.difficultyLevels.asMap().entries.map((entry) {
              return _buildTab(
                context,
                entry.value.name,
                entry.key,
                data.selectedDifficultyIndex == entry.key,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
