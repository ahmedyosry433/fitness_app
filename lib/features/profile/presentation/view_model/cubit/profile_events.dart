import 'dart:io';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String? email;
  final int? weight;
  final String? goal;
  final String? activityLevel;

  UpdateProfileEvent({
    required this.name,
    this.email,
    this.weight,
    this.goal,
    this.activityLevel,
  });
}

class UploadPhotoEvent extends ProfileEvent {}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;
  ChangePasswordEvent({required this.oldPassword, required this.newPassword});
}

class LogoutEvent extends ProfileEvent {}

class DeleteAccountEvent extends ProfileEvent {}
