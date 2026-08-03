import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseDifficultyTabs extends StatelessWidget {
  const ExerciseDifficultyTabs({super.key});

  Widget _buildTab(
    BuildContext context,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<ExerciseModuleCubit>().processIntent(
          LoadExercisesIntent(index),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleUIModel>>(
        buildWhen: (previous, current) {
          final prevData = previous.data;
          final currData = current.data;
          return prevData?.difficultyLevels != currData?.difficultyLevels ||
              prevData?.selectedDifficultyIndex !=
                  currData?.selectedDifficultyIndex;
        },
        builder: (context, state) {
          final data = state.data ?? const ExerciseModuleUIModel();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.difficultyLevels
                  .asMap()
                  .entries
                  .map((entry) {
                    return _buildTab(
                      context,
                      entry.value.name,
                      entry.key,
                      data.selectedDifficultyIndex == entry.key,
                    );
                  })
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
