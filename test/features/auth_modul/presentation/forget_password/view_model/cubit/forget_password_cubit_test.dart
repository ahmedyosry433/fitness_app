import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/base_state/base_state.dart';
// 💡 تأكد من مطابقة مسار استيراد AuthCommonResponse للموجود عندك في المشروع
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:fitness/features/auth_modul/data/models/request/forget_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/reset_password_request.dart';
import 'package:fitness/features/auth_modul/data/models/request/verify_otp_request.dart';
import 'package:fitness/features/auth_modul/domain/use_cases/forget_password_use_case.dart';
import 'package:fitness/features/auth_modul/domain/use_cases/reset_password_use_case.dart';
import 'package:fitness/features/auth_modul/domain/use_cases/verify_otp_use_case.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class FakeForgetPasswordRequest extends Fake implements ForgetPasswordRequest {}

class FakeVerifyOtpRequest extends Fake implements VerifyOtpRequest {}

class FakeResetPasswordRequest extends Fake implements ResetPasswordRequest {}

void main() {
  late ForgetPasswordCubit cubit;
  late MockForgetPasswordUseCase mockForgetPasswordUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  // 🔹 إنشاء dummy object يمثل الـ Response
  final tAuthResponse = AuthCommonResponse();

  setUpAll(() {
    registerFallbackValue(FakeForgetPasswordRequest());
    registerFallbackValue(FakeVerifyOtpRequest());
    registerFallbackValue(FakeResetPasswordRequest());
  });

  setUp(() {
    mockForgetPasswordUseCase = MockForgetPasswordUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    cubit = ForgetPasswordCubit(
      mockForgetPasswordUseCase,
      mockVerifyOtpUseCase,
      mockResetPasswordUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('Initial state should be ForgetPasswordState.initial()', () {
    expect(cubit.state, equals(const ForgetPasswordState.initial()));
  });

  group('SendOtpIntent', () {
    const tEmail = 'test@example.com';

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [loading, success] when SendOtpIntent succeeds',
      build: () {
        when(
          () => mockForgetPasswordUseCase(any()),
        ).thenAnswer((_) async => Success(data: tAuthResponse));
        return cubit;
      },
      act: (cubit) => cubit.doAction(SendOtpIntent(tEmail)),
      expect: () => [
        const ForgetPasswordState(state: StateType.loading, errorMessage: null),
        ForgetPasswordState(
          state: StateType.success,
          data: tAuthResponse,
          email: tEmail,
        ),
      ],
      verify: (_) {
        verify(() => mockForgetPasswordUseCase(any())).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [loading, error] when SendOtpIntent fails',
      build: () {
        when(
          () => mockForgetPasswordUseCase(any()),
        ).thenAnswer((_) async => Error(exception: Exception('Server Error')));
        return cubit;
      },
      act: (cubit) => cubit.doAction(SendOtpIntent(tEmail)),
      expect: () => [
        const ForgetPasswordState(state: StateType.loading, errorMessage: null),
        const ForgetPasswordState(
          state: StateType.error,
          errorMessage: 'Exception: Server Error',
        ),
      ],
      verify: (_) {
        verify(() => mockForgetPasswordUseCase(any())).called(1);
      },
    );
  });

  group('VerifyOtpIntent', () {
    const tOtp = '1234';

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [loading, success] when VerifyOtpIntent succeeds',
      build: () {
        when(
          () => mockVerifyOtpUseCase(any()),
        ).thenAnswer((_) async => Success(data: tAuthResponse));
        return cubit;
      },
      act: (cubit) => cubit.doAction( VerifyOtpIntent(tOtp)),
      expect: () => [
        const ForgetPasswordState(state: StateType.loading, errorMessage: null),
        ForgetPasswordState(
          state: StateType.success,
          data: tAuthResponse,
          otp: tOtp,
        ),
      ],
      verify: (_) {
        verify(() => mockVerifyOtpUseCase(any())).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [loading, error] when VerifyOtpIntent fails',
      build: () {
        when(
          () => mockVerifyOtpUseCase(any()),
        ).thenAnswer((_) async => Error(exception: Exception('Invalid OTP')));
        return cubit;
      },
      act: (cubit) => cubit.doAction( VerifyOtpIntent(tOtp)),
      expect: () => [
        const ForgetPasswordState(state: StateType.loading, errorMessage: null),
        const ForgetPasswordState(
          state: StateType.error,
          errorMessage: 'Exception: Invalid OTP',
        ),
      ],
      verify: (_) {
        verify(() => mockVerifyOtpUseCase(any())).called(1);
      },
    );
  });

  group('ResetPasswordSubmitIntent', () {
    const tPassword = 'Password123@';

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [loading, success] when ResetPasswordSubmitIntent succeeds',
      build: () {
        when(
          () => mockResetPasswordUseCase(any()),
        ).thenAnswer((_) async => Success(data: tAuthResponse));
        return cubit;
      },
      act: (cubit) => cubit.doAction(
         ResetPasswordSubmitIntent(
          newPassword: tPassword,
          confirmPassword: tPassword,
        ),
      ),
      expect: () => [
        const ForgetPasswordState(state: StateType.loading, errorMessage: null),
        ForgetPasswordState(
          state: StateType.success,
          data: tAuthResponse,
          newPassword: tPassword,
          confirmPassword: tPassword,
        ),
      ],
      verify: (_) {
        verify(() => mockResetPasswordUseCase(any())).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'does NOT emit new states or call usecase when passwords do not match',
      build: () => cubit,
      act: (cubit) => cubit.doAction(
         ResetPasswordSubmitIntent(
          newPassword: tPassword,
          confirmPassword: 'DifferentPassword123@',
        ),
      ),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockResetPasswordUseCase(any()));
      },
    );
  });
}