import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';

import 'package:fitness/features/auth/presentation/view_model/cubit/login/login_cubit.dart';
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
            id: 'google-user-123',
            name: 'Google User',
            email: 'google@user.com',
            token: 'token-123',
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
  late LoginCubit cubit;

  setUp(() {
    mockRepository = MockAuthRepository();
    cubit = LoginCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('Google social login emits loading and success states', () async {
    mockRepository.socialLoginResult = Success(
      data: AuthUserEntity(
        id: 'google-uid-1',
        name: 'Google User',
        email: 'google@test.com',
        token: 'token-google',
      ),
    );

    final expectedUser = AuthUserEntity(
      id: 'google-uid-1',
      name: 'Google User',
      email: 'google@test.com',
      token: 'token-google',
    );

    expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<LoginState>(
          (state) => state.loginState.state == StateType.loading,
        ),
        predicate<LoginState>(
          (state) =>
              state.loginState.state == StateType.success &&
              state.loginState.data?.email == expectedUser.email,
        ),
      ]),
    );

    await cubit.doAction(const SocialLoginEvent(AuthSocialProvider.google));
  });

  test('Facebook social login emits loading and error when login fails', () async {
    mockRepository.socialLoginResult = Error(
      exception: Exception('Facebook login cancelled'),
    );

    expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<LoginState>(
          (state) => state.loginState.state == StateType.loading,
        ),
        predicate<LoginState>(
          (state) => state.loginState.state == StateType.error,
        ),
      ]),
    );

    await cubit.doAction(const SocialLoginEvent(AuthSocialProvider.facebook));
  });
}

