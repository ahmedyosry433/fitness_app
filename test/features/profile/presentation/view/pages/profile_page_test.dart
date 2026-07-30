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
import 'package:fitness/features/profile/presentation/view/pages/profile_page.dart';

class MockProfileCubit extends MockCubit<BaseState<ProfileUIModel>> implements ProfileCubit {}

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
          builder: (context, state) => const ProfilePage(),
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
      BaseState.success(ProfileUIModel(user: user))
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
      BaseState.success(ProfileUIModel(user: user))
    );
    when(() => mockProfileCubit.doAction(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Scroll down to ensure logout icon is visible
    final scrollable = find.byType(Scrollable);
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pumpAndSettle();

    // Find logout icon/button (assuming Icons.logout is used)
    final logoutIcon = find.byIcon(Icons.logout);
    expect(logoutIcon, findsOneWidget);

    await tester.tap(logoutIcon);
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text("Are You Sure To Logout?"), findsOneWidget);
    
    // Tap the Yes button
    final yesButton = find.text("Yes");
    expect(yesButton, findsOneWidget);
    await tester.tap(yesButton);
    await tester.pumpAndSettle();

    // Verify LogoutEvent was dispatched
    verify(() => mockProfileCubit.doAction(any(that: isA<LogoutEvent>()))).called(1);
  });
}
