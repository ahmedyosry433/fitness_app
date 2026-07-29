import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/codegen_loader.g.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/exercise_module_page.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockExerciseModuleCubit
    extends MockCubit<BaseState<ExerciseModuleUIModel>>
    implements ExerciseModuleCubit {}

void main() {
  late MockExerciseModuleCubit mockCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const LoadExercisesIntent(0));
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockCubit = MockExerciseModuleCubit();
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.processIntent(any())).thenAnswer((_) async {});
    await getIt.reset();
    getIt.registerSingleton<ExerciseModuleCubit>(mockCubit);
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [arabicLocale, englishLocale],
      fallbackLocale: englishLocale,
      startLocale: englishLocale,
      path: assetsLocalization,
      assetLoader: const CodegenLoader(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp(
          home: BlocProvider<ExerciseModuleCubit>.value(
            value: mockCubit,
            child: const ExerciseModulePage(
              primeMoverMuscleId: '69d982ef85f6bfa972bf2248',
              pageTitle: 'Test Title',
              pageDescription: 'Test Description',
              backgroundImage: '',
            ),
          ),
        ),
      ),
    );
  }

  group('ExerciseModulePage Widget Tests', () {
    testWidgets('should render loading skeleton when state is loading', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      when(() => mockCubit.state).thenReturn(const BaseState.loading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.byType(ListView), findsWidgets);
    });
  });
}
