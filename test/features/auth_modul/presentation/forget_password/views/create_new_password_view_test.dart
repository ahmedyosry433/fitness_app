import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/shared/widgets/custom_button.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/views/create_new_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockForgetPasswordCubit extends MockCubit<ForgetPasswordState>
    implements ForgetPasswordCubit {}

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'forget_password': {
        'create_new_password': 'Create New Password',
        'enter_new_password': 'Enter your new password',
        'password': 'Password',
        'confirm_password': 'Confirm Password',
        'reset_password': 'Reset Password',
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
    registerFallbackValue(
      ResetPasswordSubmitIntent(newPassword: 'pass', confirmPassword: 'pass'),
    );
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
              child: const CreateNewPasswordView(),
            ),
          ),
        ),
      ),
    );
  }

  group('CreateNewPasswordView Widget Tests', () {
    testWidgets('triggers ResetPasswordSubmitIntent on submit', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.at(0), 'Password123!');
      await tester.enterText(textFields.at(1), 'Password123!');
      await tester.pump();

      final submitButton = find.byType(CustomButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(
        () => mockCubit.doAction(any(that: isA<ResetPasswordSubmitIntent>())),
      ).called(1);
    });
  });
}
