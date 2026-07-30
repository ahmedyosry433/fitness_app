import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/workout_widgets.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class WorkoutPage extends StatefulWidget {
  final String? initialCategoryId;

  const WorkoutPage({super.key, this.initialCategoryId});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  WorkoutCubit? _cubit;

  @override
  void didUpdateWidget(covariant WorkoutPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != null &&
        widget.initialCategoryId != oldWidget.initialCategoryId) {
      _cubit?.doIntent(SelectCategoryByIdEvent(widget.initialCategoryId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<WorkoutCubit>();
        _cubit = cubit;
        return cubit
          ..doIntent(
            InitWorkoutEvent(initialCategoryId: widget.initialCategoryId),
          );
      },
      child: Builder(
        builder: (context) {
          _cubit = context.read<WorkoutCubit>();
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
                  child: _WorkoutPageBody(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WorkoutPageBody extends StatefulWidget {
  const _WorkoutPageBody();

  @override
  State<_WorkoutPageBody> createState() => _WorkoutPageBodyState();
}

class _WorkoutPageBodyState extends State<_WorkoutPageBody> {
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
        const _WorkoutCategoriesBar(),
        SizedBox(height: 24.h),
        const Expanded(child: _WorkoutContent()),
      ],
    );
  }
}

class _WorkoutCategoriesBar extends StatefulWidget {
  const _WorkoutCategoriesBar();

  @override
  State<_WorkoutCategoriesBar> createState() => _WorkoutCategoriesBarState();
}

class _WorkoutCategoriesBarState extends State<_WorkoutCategoriesBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    final offset = (index * 90.w).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutCubit, WorkoutState>(
      listenWhen: (previous, current) =>
          previous.selectedCategoryIndex != current.selectedCategoryIndex,
      listener: (context, state) {
        _scrollToIndex(state.selectedCategoryIndex);
      },
      child: BlocBuilder<WorkoutCubit, WorkoutState>(
        buildWhen: (previous, current) {
          return previous.categoriesState != current.categoriesState ||
              previous.selectedCategoryIndex != current.selectedCategoryIndex;
        },
        builder: (context, state) {
          if (state.categories.isEmpty) {
            return SizedBox(height: 30.h);
          }

          return SizedBox(
            height: 30.h,
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: state.categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return WorkoutCategoryChip(
                  label: category.name,
                  isSelected: state.selectedCategoryIndex == index,
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _WorkoutContent extends StatelessWidget {
  const _WorkoutContent();

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
