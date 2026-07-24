import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/exercise_module_page.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:bloc_test/bloc_test.dart';

class MockExerciseModuleCubit extends MockCubit<BaseState<ExerciseModuleUIModel>> implements ExerciseModuleCubit {}

void main() {
  late MockExerciseModuleCubit mockCubit;

  setUp(() async {
    mockCubit = MockExerciseModuleCubit();
    await getIt.reset();
    getIt.registerSingleton<ExerciseModuleCubit>(mockCubit);
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => const MaterialApp(
        home: ExerciseModulePage(
          primeMoverMuscleId: '69d982ef85f6bfa972bf2248',
          pageTitle: 'Test Title',
          pageDescription: 'Test Description',
          backgroundImage: '',
        ),
      ),
    );
  }

  group('ExerciseModulePage Widget Tests', () {
    testWidgets('should render loading skeleton when state is loading', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const BaseState.loading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(ListView), findsOneWidget); // The skeleton list view
    });
  });
}
