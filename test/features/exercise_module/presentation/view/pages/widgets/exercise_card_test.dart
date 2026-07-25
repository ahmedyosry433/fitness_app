import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/widgets/exercise_card.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('ExerciseCard Widget Tests', () {
    const tExercise = ExerciseEntity(
      id: '1',
      title: 'Test Exercise',
      description: 'Test Description',
      videoUrl: 'https://testvideo.com',
      thumbnailUrl: 'https://testthumb.com',
      time: '15',
      calories: '150',
      level: 'Advanced',
    );

    testWidgets('should render exercise details correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(
        const ExerciseCard(exercise: tExercise),
      ));

      // Assert
      expect(find.text('Test Exercise'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });
  });
}
