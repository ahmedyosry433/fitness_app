import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness/features/profile/presentation/view/pages/profile_page.dart';
import 'package:fitness/features/profile/presentation/view/widgets/logout_confirmation_dialog.dart';
class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {}

class FakeProfileEvent extends Fake implements ProfileEvent {}

void main() {
  late MockProfileCubit mockProfileCubit;

  setUpAll(() async {
    registerFallbackValue(FakeProfileEvent());
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockProfileCubit = MockProfileCubit();
    // Register mock in getIt
    await getIt.reset();
    getIt.registerSingleton<ProfileCubit>(mockProfileCubit);
  });

  Widget createWidgetUnderTest() {
    final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<ProfileCubit>.value(
            value: mockProfileCubit,
            child: const ProfilePage(),
          ),
        ),
      ],
    );
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/localization',
      fallbackLocale: const Locale('en', 'US'),
      child: MaterialApp.router(
        routerConfig: goRouter,
      ),
    );
  }

  testWidgets('displays user name when state is success', (WidgetTester tester) async {
    final user = UserEntity(id: '1', name: 'John Doe', email: 'john@doe.com');
    
    when(() => mockProfileCubit.state).thenReturn(
      const ProfileState().copyWith(getProfileState: BaseState.success(user))
    );
    // Mock doAction to return Future
    when(() => mockProfileCubit.doAction(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('shows LogoutConfirmationDialog and calls LogoutEvent when Yes is tapped', (WidgetTester tester) async {
    final user = UserEntity(id: '1', name: 'John Doe', email: 'john@doe.com');
    
    when(() => mockProfileCubit.state).thenReturn(
      const ProfileState().copyWith(getProfileState: BaseState.success(user))
    );
    when(() => mockProfileCubit.doAction(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Find logout icon/button
    final logoutIcon = find.byIcon(Icons.logout);
    
    // Ensure it's visible before tapping
    await tester.ensureVisible(logoutIcon);
    await tester.pumpAndSettle();

    expect(logoutIcon, findsOneWidget);

    await tester.tap(logoutIcon);
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.byType(LogoutConfirmationDialog), findsOneWidget);
    
    // Tap the Yes button
    final yesButton = find.text('profile.yes');
    expect(yesButton, findsOneWidget);
    await tester.tap(yesButton);
    await tester.pumpAndSettle();

    // Verify LogoutEvent was dispatched
    verify(() => mockProfileCubit.doAction(any(that: isA<LogoutEvent>()))).called(1);
  });
}
