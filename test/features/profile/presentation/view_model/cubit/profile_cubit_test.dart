import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/core/services/image_picker_service.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/delete_account_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:fitness/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}
class MockUploadPhotoUseCase extends Mock implements UploadPhotoUseCase {}
class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}
class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockImagePickerService extends Mock implements ImagePickerService {}

void main() {
  late ProfileCubit cubit;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockUploadPhotoUseCase mockUploadPhotoUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockImagePickerService mockImagePickerService;

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockUploadPhotoUseCase = MockUploadPhotoUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockImagePickerService = MockImagePickerService();

    cubit = ProfileCubit(
      mockGetProfileUseCase,
      mockUpdateProfileUseCase,
      mockUploadPhotoUseCase,
      mockChangePasswordUseCase,
      mockDeleteAccountUseCase,
      mockLogoutUseCase,
      mockImagePickerService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ProfileCubit Tests', () {
    final tUser = UserEntity(id: '1', name: 'John Doe', email: 'test@test.com');
    final tUpdatedUser = UserEntity(id: '1', name: 'Jane Doe', email: 'test@test.com');
    final tFile = File('test.jpg');

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when LoadProfileEvent is added and use case succeeds',
      build: () {
        when(() => mockGetProfileUseCase.call()).thenAnswer((_) async => Success(data: tUser));
        return cubit;
      },
      act: (cubit) => cubit.doAction(LoadProfileEvent()),
      expect: () => [
        const ProfileState().copyWith(getProfileState: const BaseState.loading()),
        const ProfileState().copyWith(getProfileState: BaseState.success(tUser)),
      ],
      verify: (_) {
        verify(() => mockGetProfileUseCase.call()).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, error] when LoadProfileEvent is added and use case fails',
      build: () {
        when(() => mockGetProfileUseCase.call()).thenAnswer((_) async => Error(exception: Exception('Failed')));
        return cubit;
      },
      act: (cubit) => cubit.doAction(LoadProfileEvent()),
      expect: () => [
        const ProfileState().copyWith(getProfileState: const BaseState.loading()),
        isA<ProfileState>().having((s) => s.getProfileState.state, 'state', StateType.error),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when UpdateProfileEvent is added and succeeds',
      build: () {
        when(() => mockUpdateProfileUseCase.call(name: 'Jane Doe')).thenAnswer((_) async => Success(data: tUpdatedUser));
        return cubit;
      },
      act: (cubit) => cubit.doAction(UpdateProfileEvent(name: 'Jane Doe')),
      expect: () => [
        const ProfileState().copyWith(updateProfileState: const BaseState.loading()),
        const ProfileState().copyWith(
          updateProfileState: BaseState.success(tUpdatedUser),
          getProfileState: BaseState.success(tUpdatedUser),
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when UploadPhotoEvent is added and succeeds',
      build: () {
        when(() => mockImagePickerService.pickImage()).thenAnswer((_) async => tFile);
        when(() => mockUploadPhotoUseCase.call(profileImage: tFile)).thenAnswer((_) async => Success(data: tUpdatedUser));
        return cubit;
      },
      act: (cubit) => cubit.doAction(UploadPhotoEvent()),
      expect: () => [
        const ProfileState().copyWith(uploadPhotoState: const BaseState.loading()),
        const ProfileState().copyWith(
          uploadPhotoState: BaseState.success(tUpdatedUser),
          getProfileState: BaseState.success(tUpdatedUser),
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, success] when LogoutEvent is added and succeeds',
      build: () {
        when(() => mockLogoutUseCase.call()).thenAnswer((_) async => Success<void>(data: null));
        return cubit;
      },
      act: (cubit) => cubit.doAction(LogoutEvent()),
      expect: () => [
        const ProfileState().copyWith(logoutState: const BaseState.loading()),
        const ProfileState().copyWith(logoutState: const BaseState.success(null)),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase.call()).called(1);
      },
    );
  });
}
