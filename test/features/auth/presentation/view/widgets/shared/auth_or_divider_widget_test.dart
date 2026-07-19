import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_or_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AuthOrDividerWidget renders correctly with label according to Figma design 1:561',
      (WidgetTester tester) async {
    const labelText = 'Or';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AuthOrDividerWidget(label: labelText),
          ),
        ),
      ),
    );

    // Verify text label 'Or' is present
    expect(find.text(labelText), findsOneWidget);

    // Verify width constraint of the divider widget (343px per Figma design / AuthUiConfig)
    final sizedBoxFinder = find.byType(SizedBox).first;
    final SizedBox sizedBox = tester.widget(sizedBoxFinder);
    expect(sizedBox.width, equals(AuthUiConfig.orDividerWidth));

    // Verify row structure containing left line, gap, text, gap, right line
    expect(find.byType(Row), findsOneWidget);
  });
}
