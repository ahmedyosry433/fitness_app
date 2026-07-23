import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';

class ExerciseModuleTopSection extends StatelessWidget {
  const ExerciseModuleTopSection({super.key});

  Widget _buildChip(String label, {bool isOrangeText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border.all(
          color: isOrangeText ? AppColors.orangePrimary : AppColors.whiteFF.withOpacity(0.3),
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
    return Padding(
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
          SizedBox(height: 180.h), // Spacing to match the top area of the image
          
          BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleData>>(
            builder: (context, state) {
              final data = state.data ?? const ExerciseModuleData();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      data.pageTitle.isNotEmpty ? data.pageTitle : LocaleKeys.exercise_chest_exercise.tr(),
                      style: 28.bold.copyWith(
                        color: AppColors.whiteFF,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    data.pageDescription.isNotEmpty ? data.pageDescription : LocaleKeys.exercise_chest_exercise_desc.tr(),
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
          BlocBuilder<ExerciseModuleCubit, BaseState<ExerciseModuleData>>(
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
                  _buildChip('$totalMins ${LocaleKeys.exercise_min.tr()}'),
                  _buildChip('$totalCals ${LocaleKeys.exercise_cal.tr()}', isOrangeText: true),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
