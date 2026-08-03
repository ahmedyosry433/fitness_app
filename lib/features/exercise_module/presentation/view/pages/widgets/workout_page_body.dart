import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/workout_categories_bar.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/workout_content.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class WorkoutPageBody extends StatefulWidget {
  const WorkoutPageBody({super.key});

  @override
  State<WorkoutPageBody> createState() => _WorkoutPageBodyState();
}

class _WorkoutPageBodyState extends State<WorkoutPageBody> {
  StreamSubscription<WorkoutUiEvent>? _eventSub;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<WorkoutCubit>();
    _eventSub = cubit.eventStream.listen(_handleUiEvent);
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  void _handleUiEvent(WorkoutUiEvent event) {
    if (!mounted) return;
    switch (event) {
      case WorkoutErrorUiEvent(:final message):
        CustomToast(
          context: context,
          header: message.replaceAll('Exception: ', ''),
          type: ToastificationType.error,
        ).showToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Center(
          child: Text(
            LocaleKeys.home_workout.tr(),
            style: 24.bold.copyWith(color: AppColors.whiteFF),
          ),
        ),
        SizedBox(height: 24.h),
        const WorkoutCategoriesBar(),
        SizedBox(height: 24.h),
        const Expanded(child: WorkoutContent()),
      ],
    );
  }
}
