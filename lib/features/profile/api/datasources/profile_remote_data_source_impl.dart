import 'dart:io';
import 'package:fitness/features/profile/api/api_client/profile_api_client.dart';
import 'package:fitness/features/profile/data/datasources/profile_remote_data_source_contract.dart';
import 'package:fitness/features/profile/data/models/change_password_request_dto.dart';
import 'package:fitness/features/profile/data/models/profile_response_dto.dart';
import 'package:fitness/features/profile/data/models/update_profile_request_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileResponseDto> updateProfile({
    required String name,
  }) {
    return _apiClient.updateProfile(
      UpdateProfileRequestDto(name: name),
    );
  }

  @override
  Future<ProfileResponseDto> uploadPhoto({
    required File profileImage,
  }) {
    return _apiClient.uploadPhoto(profileImage: profileImage);
  }

  @override
  Future<ProfileResponseDto> getProfileData() {
    return _apiClient.getProfileData();
  }

  @override
  Future<void> changePassword(ChangePasswordRequestDto request) {
    return _apiClient.changePassword(request);
  }

  @override
  Future<void> deleteAccount() {
    return _apiClient.deleteAccount();
  }

  @override
  Future<void> logout() {
    return _apiClient.logout();
  }
}
