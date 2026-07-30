import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/delete_account_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends BaseCubit<BaseState<ProfileUIModel>, ProfileEvent> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final LogoutUseCase _logoutUseCase;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._uploadPhotoUseCase,
    this._changePasswordUseCase,
    this._deleteAccountUseCase,
    this._logoutUseCase,
  ) : super(const BaseState.initial());

  @override
  Future<void> doAction(ProfileEvent event) async {
    if (event is LoadProfileEvent) {
      await _loadProfile();
    } else if (event is UpdateProfileEvent) {
      await _updateProfile(event);
    } else if (event is ChangePasswordEvent) {
      await _changePassword(event);
    } else if (event is LogoutEvent) {
      await _logout();
    } else if (event is DeleteAccountEvent) {
      await _deleteAccount();
    }
  }

  Future<void> _loadProfile() async {
    emit(const BaseState.loading());
    final result = await _getProfileUseCase();
    result.when(
      success: (data) {
        emit(BaseState.success(ProfileUIModel(user: data)));
      },
      error: (exception) {
        emit(BaseState.error(exception));
      },
    );
  }

  Future<void> _updateProfile(UpdateProfileEvent event) async {
    final currentState = state.data;
    emit(BaseState.all(state: StateType.loading, data: currentState, exception: null));
    
    final updateResult = await _updateProfileUseCase(
      name: event.name,
    );

    await updateResult.when(
      success: (data) async {
        if (event.profileImage != null) {
          final photoResult = await _uploadPhotoUseCase(profileImage: event.profileImage!);
          photoResult.when(
            success: (photoData) {
              emit(BaseState.success(currentState?.copyWith(user: photoData) ?? ProfileUIModel(user: photoData)));
            },
            error: (exception) {
              emit(BaseState.all(state: StateType.error, data: currentState?.copyWith(user: data) ?? ProfileUIModel(user: data), exception: exception));
            },
          );
        } else {
          emit(BaseState.success(currentState?.copyWith(user: data) ?? ProfileUIModel(user: data)));
        }
      },
      error: (exception) async {
        emit(BaseState.all(state: StateType.error, data: currentState, exception: exception));
      },
    );
  }

  Future<void> _changePassword(ChangePasswordEvent event) async {
    final currentState = state.data;
    emit(BaseState.all(state: StateType.loading, data: currentState, exception: null));
    final result = await _changePasswordUseCase(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );
    result.when(
      success: (_) {
        if (currentState != null) {
          emit(BaseState.success(currentState));
        }
      },
      error: (exception) {
        emit(BaseState.all(state: StateType.error, data: currentState, exception: exception));
      },
    );
  }

  Future<void> _logout() async {
    final currentState = state.data ?? const ProfileUIModel();
    emit(BaseState.all(state: StateType.loading, data: currentState, exception: null));
    final result = await _logoutUseCase();
    result.when(
      success: (_) {
        emit(BaseState.success(currentState.copyWith(isLoggedOut: true)));
      },
      error: (exception) {
        emit(BaseState.all(state: StateType.error, data: currentState, exception: exception));
      },
    );
  }

  Future<void> _deleteAccount() async {
    final currentState = state.data ?? const ProfileUIModel();
    emit(BaseState.all(state: StateType.loading, data: currentState, exception: null));
    final result = await _deleteAccountUseCase();
    result.when(
      success: (_) {
        emit(BaseState.success(currentState.copyWith(isAccountDeleted: true)));
      },
      error: (exception) {
        emit(BaseState.all(state: StateType.error, data: currentState, exception: exception));
      },
    );
  }
}
