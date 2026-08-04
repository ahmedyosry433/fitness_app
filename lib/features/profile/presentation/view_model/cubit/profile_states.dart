import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';

class ProfileState extends Equatable {
  final BaseState<UserEntity> getProfileState;
  final BaseState<UserEntity> updateProfileState;
  final BaseState<UserEntity> uploadPhotoState;
  final BaseState<void> changePasswordState;
  final BaseState<void> logoutState;
  final BaseState<void> deleteAccountState;

  const ProfileState({
    this.getProfileState = const BaseState.initial(),
    this.updateProfileState = const BaseState.initial(),
    this.uploadPhotoState = const BaseState.initial(),
    this.changePasswordState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
    this.deleteAccountState = const BaseState.initial(),
  });

  ProfileState copyWith({
    BaseState<UserEntity>? getProfileState,
    BaseState<UserEntity>? updateProfileState,
    BaseState<UserEntity>? uploadPhotoState,
    BaseState<void>? changePasswordState,
    BaseState<void>? logoutState,
    BaseState<void>? deleteAccountState,
  }) {
    return ProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
      updateProfileState: updateProfileState ?? this.updateProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
      changePasswordState: changePasswordState ?? this.changePasswordState,
      logoutState: logoutState ?? this.logoutState,
      deleteAccountState: deleteAccountState ?? this.deleteAccountState,
    );
  }

  @override
  List<Object?> get props => [
    getProfileState,
    updateProfileState,
    uploadPhotoState,
    changePasswordState,
    logoutState,
    deleteAccountState,
  ];
}
