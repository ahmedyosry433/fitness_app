import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/workout_widgets.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutCategoriesBar extends StatefulWidget {
  const WorkoutCategoriesBar({super.key});

  @override
  State<WorkoutCategoriesBar> createState() => _WorkoutCategoriesBarState();
}

class _WorkoutCategoriesBarState extends State<WorkoutCategoriesBar> {
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
