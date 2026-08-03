import 'dart:ui';

import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/workout_page_body.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutPage extends StatefulWidget {
  final String? initialCategoryId;

  const WorkoutPage({super.key, this.initialCategoryId});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  void didUpdateWidget(covariant WorkoutPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != null &&
        widget.initialCategoryId != oldWidget.initialCategoryId) {
      context
          .read<WorkoutCubit>()
          .doIntent(SelectCategoryByIdEvent(widget.initialCategoryId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black0C,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.homeBack,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: AppColors.black.withValues(alpha: 0.55),
              ),
            ),
          ),
          const SafeArea(
            bottom: false,
            child: WorkoutPageBody(),
          ),
        ],
      ),
    );
  }
}
