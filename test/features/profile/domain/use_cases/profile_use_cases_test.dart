import 'dart:io';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/delete_account_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  
  setUp(() {
    mockRepository = MockProfileRepository();
  });

  group('GetProfileUseCase', () {
    test('should call getProfile from the repository', () async {
      final useCase = GetProfileUseCase(mockRepository);
      final tUser = UserEntity(id: '1', name: 'Test', email: 't@t.com');
      
      when(() => mockRepository.getProfile()).thenAnswer((_) async => Success(data: tUser));
      
      final result = await useCase();
      
      expect(result, isA<Success<UserEntity>>());
      verify(() => mockRepository.getProfile()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('UpdateProfileUseCase', () {
    test('should call updateProfile from the repository', () async {
      final useCase = UpdateProfileUseCase(mockRepository);
      final tUser = UserEntity(id: '1', name: 'New Name', email: 't@t.com');
      
      when(() => mockRepository.updateProfile(name: 'New Name'))
          .thenAnswer((_) async => Success(data: tUser));
      
      final result = await useCase(name: 'New Name');
      
      expect(result, isA<Success<UserEntity>>());
      verify(() => mockRepository.updateProfile(name: 'New Name')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('UploadPhotoUseCase', () {
    test('should call uploadPhoto from the repository', () async {
      final useCase = UploadPhotoUseCase(mockRepository);
      final tUser = UserEntity(id: '1', name: 'New Name', email: 't@t.com', photo: 'photo.jpg');
      final tFile = File('path/to/photo.jpg');
      
      when(() => mockRepository.uploadPhoto(profileImage: tFile))
          .thenAnswer((_) async => Success(data: tUser));
      
      final result = await useCase(profileImage: tFile);
      
      expect(result, isA<Success<UserEntity>>());
      verify(() => mockRepository.uploadPhoto(profileImage: tFile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('ChangePasswordUseCase', () {
    test('should call changePassword from the repository', () async {
      final useCase = ChangePasswordUseCase(mockRepository);
      
      when(() => mockRepository.changePassword(oldPassword: 'old', newPassword: 'new'))
          .thenAnswer((_) async => Success(data: null));
      
      final result = await useCase(oldPassword: 'old', newPassword: 'new');
      
      expect(result, isA<Success<void>>());
      verify(() => mockRepository.changePassword(oldPassword: 'old', newPassword: 'new')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('LogoutUseCase', () {
    test('should call logout from the repository', () async {
      final useCase = LogoutUseCase(mockRepository);
      
      when(() => mockRepository.logout()).thenAnswer((_) async => Success(data: null));
      
      final result = await useCase();
      
      expect(result, isA<Success<void>>());
      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('DeleteAccountUseCase', () {
    test('should call deleteAccount from the repository', () async {
      final useCase = DeleteAccountUseCase(mockRepository);
      
      when(() => mockRepository.deleteAccount()).thenAnswer((_) async => Success(data: null));
      
      final result = await useCase();
      
      expect(result, isA<Success<void>>());
      verify(() => mockRepository.deleteAccount()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
