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
import 'package:fitness/features/profile/presentation/view/pages/edit_profile_page.dart';
import 'package:go_router/go_router.dart';

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
    await getIt.reset();
    getIt.registerSingleton<ProfileCubit>(mockProfileCubit);
  });

  Widget createWidgetUnderTest() {
    final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const EditProfilePage(),
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

  testWidgets('displays user name and email in text fields on success state', (WidgetTester tester) async {
    final user = UserEntity(id: '1', name: 'John Doe', email: 'john@doe.com');
    
    final successState = const ProfileState().copyWith(getProfileState: BaseState.success(user));
    
    when(() => mockProfileCubit.state).thenReturn(successState);
    whenListen(
      mockProfileCubit,
      Stream.fromIterable([successState]),
      initialState: const ProfileState(),
    );
    when(() => mockProfileCubit.doAction(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Check if the TextFields are populated
    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text('john@doe.com'), findsOneWidget);
  });

  testWidgets('shows validation error when name is empty and save is tapped', (WidgetTester tester) async {
    final user = UserEntity(id: '1', name: '', email: 'john@doe.com');
    
    final successState = const ProfileState().copyWith(getProfileState: BaseState.success(user));
    
    when(() => mockProfileCubit.state).thenReturn(successState);
    whenListen(
      mockProfileCubit,
      Stream.fromIterable([successState]),
      initialState: const ProfileState(),
    );
    when(() => mockProfileCubit.doAction(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap save button
    final saveIcon = find.byIcon(Icons.check);
    await tester.tap(saveIcon);
    await tester.pumpAndSettle();
    
    // Pump out the toastification timer (3 seconds)
    await tester.pump(const Duration(seconds: 4));

    // The cubit action should not be called due to validation
    verifyNever(() => mockProfileCubit.doAction(any(that: isA<UpdateProfileEvent>())));
  });

  testWidgets('calls UpdateProfileEvent when valid data and save is tapped', (WidgetTester tester) async {
    final user = UserEntity(id: '1', name: 'John Doe', email: 'john@doe.com');
    
    final successState = const ProfileState().copyWith(getProfileState: BaseState.success(user));
    
    when(() => mockProfileCubit.state).thenReturn(successState);
    whenListen(
      mockProfileCubit,
      Stream.fromIterable([successState]),
      initialState: const ProfileState(),
    );
    when(() => mockProfileCubit.doAction(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final saveIcon = find.byIcon(Icons.check);
    await tester.tap(saveIcon);
    await tester.pumpAndSettle();

    verify(() => mockProfileCubit.doAction(any(that: isA<UpdateProfileEvent>()))).called(1);
  });
}
