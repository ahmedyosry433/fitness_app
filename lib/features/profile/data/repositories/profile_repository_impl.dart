import 'dart:io';
import 'package:fitness/config/api/api_executer.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/data/datasources/profile_remote_data_source_contract.dart';
import 'package:fitness/features/profile/data/models/change_password_request_dto.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness/core/user_helper/user_helper.dart';
import 'package:fitness/features/profile/data/models/profile_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSourceContract _remoteDataSource;
  final UserHelper _userHelper;

  ProfileRepositoryImpl(this._remoteDataSource, this._userHelper);

  UserEntity _mapToEntity(ProfileResponseDto response, {String? defaultName}) {
    return UserEntity(
      id: response.data?.id ?? '',
      name: response.data?.name ?? defaultName ?? '',
      email: response.data?.email ?? '',
      photo: response.data?.photo,
    );
  }

  @override
  Future<Result<UserEntity>> getProfile() async {
    return executeApi(() async {
      final response = await _remoteDataSource.getProfileData();
      return _mapToEntity(response);
    });
  }

  @override
  Future<Result<UserEntity>> updateProfile({
    required String name,
  }) async {
    return executeApi(() async {
      final response = await _remoteDataSource.updateProfile(
        name: name,
      );
      return _mapToEntity(response, defaultName: name);
    });
  }

  @override
  Future<Result<UserEntity>> uploadPhoto({
    required File profileImage,
  }) async {
    return executeApi(() async {
      final response = await _remoteDataSource.uploadPhoto(
        profileImage: profileImage,
      );
      return _mapToEntity(response);
    });
  }

  @override
  Future<Result<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return executeApi(() async {
      final request = ChangePasswordRequestDto(
        passwordCurrent: oldPassword,
        password: newPassword,
        passwordConfirm: newPassword,
      );
      await _remoteDataSource.changePassword(request);
    });
  }

  @override
  Future<Result<void>> deleteAccount() async {
    return executeApi(() async {
      await _remoteDataSource.deleteAccount();
      await _userHelper.clearUserData();
    });
  }

  @override
  Future<Result<void>> logout() async {
    return executeApi(() async {
      await _remoteDataSource.logout();
      await _userHelper.clearUserData();
    });
  }
}
