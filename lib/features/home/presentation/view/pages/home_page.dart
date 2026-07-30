import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/recommendation_to_day_section.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/upcoming_workouts_section.dart';
import 'package:fitness/features/food/presentation/food_recommendation/widgets/food_recommendation_home_section.dart';
import 'package:fitness/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:fitness/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:fitness/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HomeCubit>()..processIntent(const LoadHomeIntent()),
      child: Scaffold(
        extendBody: true,
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
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
            SafeArea(
              child: BlocBuilder<HomeCubit, BaseState<HomeUIModel>>(
                builder: (context, state) {
                  final data = state.data ?? const HomeUIModel();
                  final displayName =
                      data.userName.isNotEmpty ? data.userName : 'User';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.home_hi_name.tr(args: [displayName]),
                                  style: 16.regular.copyWith(
                                    color: AppColors.whiteFF,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  LocaleKeys.home_lets_start_your_day.tr(),
                                  style: 20.bold.copyWith(
                                    color: AppColors.whiteFF,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: AppColors.gray5F,
                              backgroundImage: (data.userPhoto != null &&
                                      data.userPhoto!.isNotEmpty)
                                  ? NetworkImage(data.userPhoto!)
                                  : const AssetImage(AppImages.humanGym)
                                      as ImageProvider,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                        final data = state.data ?? const HomeUIModel();
                        final isLoading = state.state == StateType.loading ||
                            state.state == StateType.initial;

                        if (state.state == StateType.error &&
                            data.randomMuscles.isEmpty &&
                            data.muscleGroups.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Text(
                                state.errorMessage ??
                                    LocaleKeys.exercise_failed_to_load.tr(
                                      args: [''],
                                    ),
                                style: 14.regular.copyWith(
                                  color: AppColors.whiteFF,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        final recommendationItems = data.randomMuscles
                            .take(8)
                            .map(
                              (muscle) => RecommendationItem(
                                title: muscle.name,
                                imagePath: muscle.imageUrl,
                                onTap: () => _openExerciseModule(
                                  context,
                                  muscleId: muscle.id,
                                  title: muscle.name,
                                  imageUrl: muscle.imageUrl,
                                ),
                              ),
                            )
                            .toList();

                        final filters = data.muscleGroups
                            .map(
                              (group) => WorkoutFilter(
                                id: group.id,
                                label: group.name,
                              ),
                            )
                            .toList();

                        final categories = data.groupMuscles
                            .map(
                              (muscle) => WorkoutCategoryItem(
                                id: muscle.id,
                                title: muscle.name,
                                imagePath: muscle.imageUrl,
                                onTap: () => _openExerciseModule(
                                  context,
                                  muscleId: muscle.id,
                                  title: muscle.name,
                                  imageUrl: muscle.imageUrl,
                                ),
                              ),
                            )
                            .toList();

                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RecommendationToDaySection(
                                items: recommendationItems,
                                isLoading: isLoading,
                              ),
                              SizedBox(height: 24.h),
                              const FoodRecommendationHomeSection(),
                              SizedBox(height: 24.h),
                              UpcomingWorkoutsSection(
                                filters: filters,
                                categories: categories,
                                selectedFilterId: data.selectedMuscleGroupId,
                                isLoading: isLoading,
                                isLoadingCategories:
                                    data.isLoadingGroupMuscles,
                                onFilterSelected: (id) {
                                  context.read<HomeCubit>().processIntent(
                                        SelectMuscleGroupIntent(id),
                                      );
                                  context.go(Routes.workout, extra: id);
                                },
                                onSeeAllTap: () => context.go(
                                  Routes.workout,
                                  extra: data.selectedMuscleGroupId,
                                ),
                              ),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
          ],
        ),
      ),
    );
  }
}

void _openExerciseModule(
  BuildContext context, {
  required String muscleId,
  required String title,
  required String imageUrl,
}) {
  context.push(
    Routes.exercise,
    extra: {
      'primeMoverMuscleId': muscleId,
      'pageTitle': title,
      'pageDescription': '',
      'backgroundImage': imageUrl,
    },
  );
}
