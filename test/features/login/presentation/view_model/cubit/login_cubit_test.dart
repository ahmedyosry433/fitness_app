import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/auth_social_provider.dart';
import 'package:fitness/features/login/domain/repositories/login_repository.dart';
import 'package:fitness/features/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginCubit cubit;
  late MockLoginRepository mockLoginRepository;

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    cubit = LoginCubit(mockLoginRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginCubit', () {
    const tAuthUserEntity = AuthUserEntity(
      id: '1',
      token: 'token',
      name: 'Test',
      email: 'test@test.com',
      phone: '1234567890',
    );

    test('initial state should be LoginState()', () {
      expect(cubit.state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'emits loading then success state and navigates when LoginSubmittedEvent succeeds',
      build: () {
        when(() => mockLoginRepository.login(params: any(named: 'params')))
            .thenAnswer((_) async => const Success(data: tAuthUserEntity));
        return cubit;
      },
      act: (cubit) => cubit.doAction(const LoginSubmittedEvent(email: 'test@test.com', password: 'password')),
      expect: () => [
        const LoginState(loginState: BaseState.loading()),
        const LoginState(loginState: BaseState.success(tAuthUserEntity)),
      ],
      verify: (cubit) {
        verify(() => mockLoginRepository.login(params: any(named: 'params'))).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits loading then error state and navigates when LoginSubmittedEvent fails',
      build: () {
        when(() => mockLoginRepository.login(params: any(named: 'params')))
            .thenAnswer((_) async => Error(exception: Exception('Error occurred')));
        return cubit;
      },
      act: (cubit) => cubit.doAction(const LoginSubmittedEvent(email: 'test@test.com', password: 'password')),
      expect: () => [
        const LoginState(loginState: BaseState.loading()),
        isA<LoginState>()
            .having((state) => state.loginState.state, 'state', StateType.error)
            .having((state) => state.loginState.exception.toString(), 'exception', contains('Error occurred')),
      ],
      verify: (cubit) {
        verify(() => mockLoginRepository.login(params: any(named: 'params'))).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'toggles password visibility when TogglePasswordVisibilityEvent is added',
      build: () => cubit,
      act: (cubit) {
        cubit.doAction(const TogglePasswordVisibilityEvent());
        cubit.doAction(const TogglePasswordVisibilityEvent());
      },
      expect: () => [
        const LoginState(isPasswordHidden: false),
        const LoginState(isPasswordHidden: true),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits loading then initial with error navigation when SocialLoginEvent is added',
      build: () => cubit,
      act: (cubit) => cubit.doAction(const SocialLoginEvent(AuthSocialProvider.google)),
      expect: () => [
        const LoginState(loginState: BaseState.loading()),
        const LoginState(loginState: BaseState.initial()),
      ],
    );
  });
}
