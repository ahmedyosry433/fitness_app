import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitness/config/api/app_endpoints.dart';
import 'package:fitness/features/profile/data/models/change_password_request_dto.dart';
import 'package:fitness/features/profile/data/models/profile_response_dto.dart';
import 'package:injectable/injectable.dart';

part 'profile_api_client.g.dart';

@RestApi()
@lazySingleton
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @PATCH(AppEndPoints.profileData)
  @MultiPart()
  Future<ProfileResponseDto> updateProfile({
    @Part(name: AppEndPoints.nameParam) required String name,
  });

  @PATCH(AppEndPoints.uploadPhoto)
  @MultiPart()
  Future<ProfileResponseDto> uploadPhoto({
    @Part(name: AppEndPoints.photoParam) required File profileImage,
  });

  @GET(AppEndPoints.profileData)
  Future<ProfileResponseDto> getProfileData();

  @PATCH(AppEndPoints.changePassword)
  Future<void> changePassword(@Body() ChangePasswordRequestDto request);

  @DELETE(AppEndPoints.deleteMe)
  Future<void> deleteAccount();

  @POST(AppEndPoints.logout)
  Future<void> logout();
}
