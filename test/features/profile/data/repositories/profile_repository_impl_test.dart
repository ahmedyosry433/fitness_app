import 'dart:io';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/data/datasources/profile_remote_data_source_contract.dart';
import 'package:fitness/features/profile/data/models/profile_response_dto.dart';
import 'package:fitness/features/profile/data/models/change_password_request_dto.dart';
import 'package:fitness/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fitness/core/user_helper/user_helper.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSourceContract {}

class MockUserHelper extends Mock implements UserHelper {}

class MockInternetConnection extends Mock implements InternetConnection {}

class FakeChangePasswordRequestDto extends Fake implements ChangePasswordRequestDto {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockUserHelper mockUserHelper;

  late MockInternetConnection mockInternetConnection;

  setUpAll(() {
    registerFallbackValue(FakeChangePasswordRequestDto());
  });

  setUp(() async {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockUserHelper = MockUserHelper();
    mockInternetConnection = MockInternetConnection();
    
    await getIt.reset();
    getIt.registerSingleton<InternetConnection>(mockInternetConnection);
    when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);

    repository = ProfileRepositoryImpl(mockRemoteDataSource, mockUserHelper);
  });

  group('updateProfile', () {
    test('should return Success with UserEntity when update is successful', () async {
      // Arrange
      const tName = 'John Doe';
      final tProfileResponse = ProfileResponseDto(
        data: UserDto(id: '1', name: tName, email: 'john@test.com', photo: 'photo_url'),
        message: 'Success',
      );
      
      when(() => mockRemoteDataSource.updateProfile(name: tName))
          .thenAnswer((_) async => tProfileResponse);

      // Act
      final result = await repository.updateProfile(name: tName);

      // Assert
      expect(result, isA<Success>());
      result.when(
        success: (user) {
          expect(user!.name, equals(tName));
          expect(user.id, equals('1'));
          expect(user.email, equals('john@test.com'));
        },
        error: (_) => fail('Should not return error'),
      );
      verify(() => mockRemoteDataSource.updateProfile(name: tName)).called(1);
    });

    test('should return Error when update fails', () async {
      // Arrange
      const tName = 'John Doe';
      final exception = Exception('Update failed');
      when(() => mockRemoteDataSource.updateProfile(name: tName))
          .thenThrow(exception);

      // Act
      final result = await repository.updateProfile(name: tName);

      // Assert
      expect(result, isA<Error>());
      verify(() => mockRemoteDataSource.updateProfile(name: tName)).called(1);
    });
  });

  group('deleteAccount', () {
    test('should clear user data and return Success when delete is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteAccount()).thenAnswer((_) async {});
      when(() => mockUserHelper.clearUserData()).thenAnswer((_) async {});

      // Act
      final result = await repository.deleteAccount();

      // Assert
      expect(result, isA<Success>());
      verify(() => mockRemoteDataSource.deleteAccount()).called(1);
      verify(() => mockUserHelper.clearUserData()).called(1);
    });
  });

  group('changePassword', () {
    test('should return Success when changePassword is successful', () async {
      // Arrange
      const tOldPassword = 'oldPassword';
      const tNewPassword = 'newPassword';
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.changePassword(
        oldPassword: tOldPassword,
        newPassword: tNewPassword,
      );

      // Assert
      expect(result, isA<Success>());
      verify(() => mockRemoteDataSource.changePassword(any())).called(1);
    });
  });

  group('logout', () {
    test('should clear user data and return Success when logout is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
      when(() => mockUserHelper.clearUserData()).thenAnswer((_) async {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<Success>());
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockUserHelper.clearUserData()).called(1);
    });
  });

  group('getProfile', () {
    test('should return Success with UserEntity when getProfileData is successful', () async {
      // Arrange
      final tProfileResponse = ProfileResponseDto(
        data: UserDto(id: '1', name: 'User', email: 'user@test.com', photo: 'photo_url'),
        message: 'Success',
      );
      when(() => mockRemoteDataSource.getProfileData())
          .thenAnswer((_) async => tProfileResponse);

      // Act
      final result = await repository.getProfile();

      // Assert
      expect(result, isA<Success>());
      result.when(
        success: (user) {
          expect(user!.name, equals('User'));
          expect(user.id, equals('1'));
        },
        error: (_) => fail('Should not return error'),
      );
      verify(() => mockRemoteDataSource.getProfileData()).called(1);
    });
  });

  group('uploadPhoto', () {
    test('should return Success with UserEntity when uploadPhoto is successful', () async {
      // Arrange
      final tFile = File('path/to/file');
      final tProfileResponse = ProfileResponseDto(
        data: UserDto(id: '1', name: 'User', email: 'user@test.com', photo: 'new_photo_url'),
        message: 'Success',
      );
      when(() => mockRemoteDataSource.uploadPhoto(profileImage: tFile))
          .thenAnswer((_) async => tProfileResponse);

      // Act
      final result = await repository.uploadPhoto(profileImage: tFile);

      // Assert
      expect(result, isA<Success>());
      result.when(
        success: (user) {
          expect(user!.photo, equals('new_photo_url'));
        },
        error: (_) => fail('Should not return error'),
      );
      verify(() => mockRemoteDataSource.uploadPhoto(profileImage: tFile)).called(1);
    });
  });
}
