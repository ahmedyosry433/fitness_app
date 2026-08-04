import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/shared/widgets/custom_button.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/views/otp_verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockForgetPasswordCubit extends MockCubit<ForgetPasswordState>
    implements ForgetPasswordCubit {}

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'forget_password': {
        'otp_code': 'OTP Code',
        'enter_otp_check_email': 'Check your email for OTP',
        'invalid_otp_code': 'Invalid OTP',
        'confirm': 'Confirm',
        'didnt_receive_code': "Didn't receive code?",
        'resend_code': 'Resend Code',
      },
    };
  }
}

void main() {
  late MockForgetPasswordCubit mockCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    registerFallbackValue(VerifyOtpIntent('1234'));
  });

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    when(() => mockCubit.state).thenReturn(const ForgetPasswordState.initial());
    when(() => mockCubit.doAction(any())).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      assetLoader: const TestAssetLoader(),
      startLocale: const Locale('en'),
      child: Builder(
        builder: (context) => ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocProvider<ForgetPasswordCubit>.value(
              value: mockCubit,
              child: const OtpVerificationView(),
            ),
          ),
        ),
      ),
    );
  }

  group('OtpVerificationView Widget Tests', () {
    testWidgets('renders Pinput and Confirm button correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Pinput), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('triggers VerifyOtpIntent when OTP submitted', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(Pinput), '1234');
      await tester.pump();

      final confirmButton = find.byType(CustomButton);
      await tester.ensureVisible(confirmButton);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      verify(
        () => mockCubit.doAction(any(that: isA<VerifyOtpIntent>())),
      ).called(1);
    });
  });
}
