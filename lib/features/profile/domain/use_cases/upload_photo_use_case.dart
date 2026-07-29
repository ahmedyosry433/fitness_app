import 'dart:io';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UploadPhotoUseCase {
  final ProfileRepository _repository;

  UploadPhotoUseCase(this._repository);

  Future<Result<UserEntity>> call({required File profileImage}) async {
    return await _repository.uploadPhoto(profileImage: profileImage);
  }
}
