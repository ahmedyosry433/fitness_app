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
import 'package:fitness/core/services/image_picker_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState, ProfileEvent, void> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final LogoutUseCase _logoutUseCase;
  final ImagePickerService _imagePickerService;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._uploadPhotoUseCase,
    this._changePasswordUseCase,
    this._deleteAccountUseCase,
    this._logoutUseCase,
    this._imagePickerService,
  ) : super(const ProfileState());

  @override
  Future<void> doAction(ProfileEvent event) async {
    switch (event) {
      case LoadProfileEvent():
        await _loadProfile();
        break;
      case UpdateProfileEvent():
        await _updateProfile(event);
        break;
      case UploadPhotoEvent():
        await _uploadPhoto();
        break;
      case ChangePasswordEvent():
        await _changePassword(event);
        break;
      case LogoutEvent():
        await _logout();
        break;
      case DeleteAccountEvent():
        await _deleteAccount();
        break;
    }
  }

  Future<void> _loadProfile() async {
    if (state.getProfileState.data != null) return;
    emit(state.copyWith(getProfileState: const BaseState.loading()));
    final result = await _getProfileUseCase();
    result.when(
      success: (data) {
        emit(state.copyWith(getProfileState: BaseState.success(data)));
      },
      error: (errorMessage) {
        emit(state.copyWith(getProfileState: BaseState.error(errorMessage)));
      },
    );
  }

  Future<void> _updateProfile(UpdateProfileEvent event) async {
    final currentData = state.getProfileState.data;
    emit(
      state.copyWith(
        updateProfileState: BaseState.all(
          state: StateType.loading,
          data: currentData,
          errorMessage: null,
        ),
      ),
    );

    final updateResult = await _updateProfileUseCase(
      name: event.name,
      email: event.email,
      weight: event.weight,
      goal: event.goal,
      activityLevel: event.activityLevel,
    );

    updateResult.when(
      success: (data) {
        emit(
          state.copyWith(
            updateProfileState: BaseState.success(data),
            getProfileState: BaseState.success(
              data,
            ), // Update general profile too
          ),
        );
      },
      error: (errorMessage) {
        emit(state.copyWith(updateProfileState: BaseState.error(errorMessage)));
      },
    );
  }

  Future<void> _uploadPhoto() async {
    final file = await _imagePickerService.pickImage();
    if (file == null) return; // User cancelled

    final currentData = state.getProfileState.data;
    emit(
      state.copyWith(
        uploadPhotoState: BaseState.all(
          state: StateType.loading,
          data: currentData,
          errorMessage: null,
        ),
      ),
    );

    final photoResult = await _uploadPhotoUseCase(profileImage: file);
    photoResult.when(
      success: (photoData) {
        emit(
          state.copyWith(
            uploadPhotoState: BaseState.success(photoData),
            getProfileState: BaseState.success(
              photoData,
            ), // Update general profile too
          ),
        );
      },
      error: (errorMessage) {
        emit(state.copyWith(uploadPhotoState: BaseState.error(errorMessage)));
      },
    );
  }

  Future<void> _changePassword(ChangePasswordEvent event) async {
    emit(state.copyWith(changePasswordState: const BaseState.loading()));
    final result = await _changePasswordUseCase(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );
    result.when(
      success: (_) {
        emit(
          state.copyWith(changePasswordState: const BaseState.success(null)),
        );
      },
      error: (errorMessage) {
        emit(
          state.copyWith(changePasswordState: BaseState.error(errorMessage)),
        );
      },
    );
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: const BaseState.loading()));
    final result = await _logoutUseCase();
    result.when(
      success: (_) {
        emit(state.copyWith(logoutState: const BaseState.success(null)));
      },
      error: (errorMessage) {
        emit(state.copyWith(logoutState: BaseState.error(errorMessage)));
      },
    );
  }

  Future<void> _deleteAccount() async {
    emit(state.copyWith(deleteAccountState: const BaseState.loading()));
    final result = await _deleteAccountUseCase();
    result.when(
      success: (_) {
        emit(state.copyWith(deleteAccountState: const BaseState.success(null)));
      },
      error: (errorMessage) {
        emit(state.copyWith(deleteAccountState: BaseState.error(errorMessage)));
      },
    );
  }
}
