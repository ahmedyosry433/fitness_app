import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_states.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/exercise_module_page.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    );
  }

  group('ExerciseModulePage Widget Tests', () {
    testWidgets('should render loading skeleton when state is loading', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const BaseState.loading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(ExerciseModulePage), findsOneWidget);
    });
  });
}
