import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/widgets/custom_back_button.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseModuleHeader extends StatelessWidget {
  const ExerciseModuleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const CustomBackButton(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
              BlocBuilder<
                ExerciseModuleCubit,
                BaseState<ExerciseModuleUIModel>
              >(
                buildWhen: (previous, current) {
                  return previous.data?.pageTitle != current.data?.pageTitle ||
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
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: AppColors.whiteFF,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                        ),
                      ),
                      const SizedBox(height: 125),
                      Text(
                        data.pageDescription.isNotEmpty
                            ? data.pageDescription
                            : LocaleKeys.exercise_chest_exercise_desc.tr(),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.whiteFF.withValues(alpha: 0.8),
                          height: 1.4,
                          fontSize: 14,
                          fontFamily: 'RobotoEnglish',
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ],
    );
  }
}
