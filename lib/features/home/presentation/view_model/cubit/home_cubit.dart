import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/user_helper/user_helper.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_entity.dart';
import 'package:fitness/features/exercise_module/domain/entities/muscle_group_entity.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness/features/exercise_module/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:fitness/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:fitness/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<BaseState<HomeUIModel>> {
  final GetMuscleGroupsUseCase getMuscleGroupsUseCase;
  final GetRandomMusclesUseCase getRandomMusclesUseCase;
  final GetMusclesByGroupUseCase getMusclesByGroupUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UserHelper userHelper;

  HomeCubit(
    this.getMuscleGroupsUseCase,
    this.getRandomMusclesUseCase,
    this.getMusclesByGroupUseCase,
    this.getProfileUseCase,
    this.userHelper,
  ) : super(const BaseState.initial());

  HomeUIModel get _data => state.data ?? const HomeUIModel();

  void processIntent(HomeIntent intent) {
    switch (intent) {
      case LoadHomeIntent():
        _loadHome();
      case SelectMuscleGroupIntent(:final muscleGroupId):
        _selectMuscleGroup(muscleGroupId);
    }
  }

  Future<void> _loadHome() async {
    emit(
      BaseState.all(
        state: StateType.loading,
        data: _data,
        exception: null,
      ),
    );

    final randomFuture = getRandomMusclesUseCase();
    final groupsFuture = getMuscleGroupsUseCase();
    final profileFuture = getProfileUseCase();

    final cachedName = await userHelper.getUserName();
    final cachedPhoto = await userHelper.getUserPhoto();

    final randomResult = await randomFuture;
    final groupsResult = await groupsFuture;
    final profileResult = await profileFuture;

    Exception? error;
    List<MuscleEntity> randomMuscles = _data.randomMuscles;
    List<MuscleGroupEntity> muscleGroups = _data.muscleGroups;
    String userName = cachedName ?? '';
    String? userPhoto = cachedPhoto;

    profileResult.when(
      success: (user) {
        if (user != null) {
          if (user.name.isNotEmpty) {
            userName = user.name;
          }
          if (user.photo != null && user.photo!.isNotEmpty) {
            userPhoto = user.photo;
          }
        }
      },
      error: (_) {},
    );

    randomResult.when(
      success: (data) {
        if (data != null) randomMuscles = data;
      },
      error: (exception) => error = exception,
    );

    groupsResult.when(
      success: (data) {
        if (data != null) muscleGroups = data;
      },
      error: (exception) => error ??= exception,
    );

    if (error != null && randomMuscles.isEmpty && muscleGroups.isEmpty) {
      emit(
        BaseState.all(
          state: StateType.error,
          data: _data.copyWith(userName: userName, userPhoto: userPhoto),
          exception: error,
        ),
      );
      return;
    }

    final selectedId = muscleGroups.isNotEmpty
        ? (_data.selectedMuscleGroupId.isNotEmpty &&
                muscleGroups.any((g) => g.id == _data.selectedMuscleGroupId)
            ? _data.selectedMuscleGroupId
            : muscleGroups.first.id)
        : '';

    emit(
      BaseState.all(
        state: StateType.success,
        data: _data.copyWith(
          randomMuscles: randomMuscles,
          muscleGroups: muscleGroups,
          selectedMuscleGroupId: selectedId,
          isLoadingGroupMuscles: selectedId.isNotEmpty,
          groupMuscles: const [],
          userName: userName,
          userPhoto: userPhoto,
        ),
        exception: null,
      ),
    );

    if (selectedId.isNotEmpty) {
      await _loadMusclesForGroup(selectedId);
    }
  }

  Future<void> _selectMuscleGroup(String muscleGroupId) async {
    if (muscleGroupId == _data.selectedMuscleGroupId &&
        _data.groupMuscles.isNotEmpty) {
      return;
    }

    emit(
      BaseState.all(
        state: StateType.success,
        data: _data.copyWith(
          selectedMuscleGroupId: muscleGroupId,
          isLoadingGroupMuscles: true,
          groupMuscles: const [],
        ),
        exception: null,
      ),
    );

    await _loadMusclesForGroup(muscleGroupId);
  }

  Future<void> _loadMusclesForGroup(String muscleGroupId) async {
    final result = await getMusclesByGroupUseCase(
      muscleGroupId: muscleGroupId,
    );

    // Ignore stale responses if the user switched groups quickly.
    if (_data.selectedMuscleGroupId != muscleGroupId) return;

    result.when(
      success: (muscles) {
        emit(
          BaseState.all(
            state: StateType.success,
            data: _data.copyWith(
              groupMuscles: muscles ?? const [],
              isLoadingGroupMuscles: false,
            ),
            exception: null,
          ),
        );
      },
      error: (exception) {
        emit(
          BaseState.all(
            state: StateType.success,
            data: _data.copyWith(
              groupMuscles: const [],
              isLoadingGroupMuscles: false,
            ),
            exception: exception,
          ),
        );
      },
    );
  }
}
