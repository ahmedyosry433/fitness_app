import 'dart:io';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<UserEntity>> getProfile();

  Future<Result<UserEntity>> updateProfile({
    required String name,
  });

  Future<Result<UserEntity>> uploadPhoto({
    required File profileImage,
  });

  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Result<void>> deleteAccount();

  Future<Result<void>> logout();
}
