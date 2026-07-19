import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/register/register_cubit.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';

class MockAuthRepository implements AuthRepository {
  Result<AuthUserEntity>? socialLoginResult;

  @override
  Future<Result<AuthUserEntity>> socialLogin({
    required AuthSocialProvider provider,
  }) async {
    return socialLoginResult ??
        Success(
          data: AuthUserEntity(
            id: 'facebook-user-123',
            name: 'Facebook User',
            email: 'fb@user.com',
            token: 'token-fb-123',
          ),
        );
  }

  @override
  Future<Result<AuthUserEntity>> login({required LoginParams params}) async =>
      const Success(data: AuthUserEntity());

  @override
  Future<Result<AuthUserEntity>> register({
    required RegisterParams params,
  }) async =>
      const Success(data: AuthUserEntity());

  @override
  Future<Result<void>> forgotPassword({
    required ForgotPasswordParams params,
  }) async =>
      const Success(data: null);

  @override
  Future<Result<void>> logout() async => const Success(data: null);
}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterCubit cubit;

  setUp(() {
    mockRepository = MockAuthRepository();
    cubit = RegisterCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('Google social register emits loading and success states', () async {
    mockRepository.socialLoginResult = Success(
      data: AuthUserEntity(
        id: 'google-uid-reg',
        name: 'Google Registered User',
        email: 'googlereg@test.com',
        token: 'token-google-reg',
      ),
    );

    expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<RegisterState>(
          (state) => state.registerState.state == StateType.loading,
        ),
        predicate<RegisterState>(
          (state) =>
              state.registerState.state == StateType.success &&
              state.registerState.data?.email == 'googlereg@test.com',
        ),
      ]),
    );

    await cubit.doAction(const SocialRegisterEvent(AuthSocialProvider.google));
  });

  test('Facebook social register emits loading and error when register fails', () async {
    mockRepository.socialLoginResult = Error(
      exception: Exception('Facebook sign up cancelled'),
    );

    expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<RegisterState>(
          (state) => state.registerState.state == StateType.loading,
        ),
        predicate<RegisterState>(
          (state) => state.registerState.state == StateType.error,
        ),
      ]),
    );

    await cubit.doAction(const SocialRegisterEvent(AuthSocialProvider.facebook));
  });
}
