import 'dart:io';
import 'package:fitness/features/profile/data/models/change_password_request_dto.dart';
import 'package:fitness/features/profile/data/models/profile_response_dto.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<ProfileResponseDto> updateProfile({
    required String name,
  });

  Future<ProfileResponseDto> uploadPhoto({
    required File profileImage,
  });

  Future<ProfileResponseDto> getProfileData();

  Future<void> changePassword(ChangePasswordRequestDto request);

  Future<void> deleteAccount();

  Future<void> logout();
}
