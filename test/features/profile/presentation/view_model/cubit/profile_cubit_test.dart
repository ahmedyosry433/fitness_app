import 'package:bloc_test/bloc_test.dart';
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

void main() {
  late ProfileCubit cubit;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockUploadPhotoUseCase mockUploadPhotoUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockUploadPhotoUseCase = MockUploadPhotoUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    cubit = ProfileCubit(
      mockGetProfileUseCase,
      mockUpdateProfileUseCase,
      mockUploadPhotoUseCase,
      mockChangePasswordUseCase,
      mockDeleteAccountUseCase,
      mockLogoutUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ProfileCubit Tests', () {
    final tUser = UserEntity(id: '1', name: 'John Doe', email: 'test@test.com');

    blocTest<ProfileCubit, BaseState<ProfileUIModel>>(
      'emits [loading, success] when LoadProfileEvent is added and use case succeeds',
      build: () {
        when(() => mockGetProfileUseCase.call()).thenAnswer((_) async => Success(data: tUser));
        return cubit;
      },
      act: (cubit) => cubit.doAction(LoadProfileEvent()),
      expect: () => [
        const BaseState<ProfileUIModel>.loading(),
        BaseState<ProfileUIModel>.success(ProfileUIModel(user: tUser)),
      ],
      verify: (_) {
        verify(() => mockGetProfileUseCase.call()).called(1);
      },
    );

    blocTest<ProfileCubit, BaseState<ProfileUIModel>>(
      'emits [loading, error] when LoadProfileEvent is added and use case fails',
      build: () {
        when(() => mockGetProfileUseCase.call()).thenAnswer((_) async => Error(exception: Exception('Failed to load profile')));
        return cubit;
      },
      act: (cubit) => cubit.doAction(LoadProfileEvent()),
      expect: () => [
        const BaseState<ProfileUIModel>.loading(),
        isA<BaseState<ProfileUIModel>>().having((s) => s.state, 'state', StateType.error),
      ],
    );

    blocTest<ProfileCubit, BaseState<ProfileUIModel>>(
      'emits [loading, success] when LogoutEvent is added and succeeds',
      build: () {
        when(() => mockLogoutUseCase.call()).thenAnswer((_) async => Success<void>(data: null));
        return cubit;
      },
      act: (cubit) => cubit.doAction(LogoutEvent()),
      expect: () => [
        const BaseState<ProfileUIModel>.all(state: StateType.loading, data: ProfileUIModel(), exception: null),
        const BaseState<ProfileUIModel>.success(ProfileUIModel(isLoggedOut: true)),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase.call()).called(1);
      },
    );
  });
}
