import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_social_login_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AuthSocialLoginRowWidget renders 3 social buttons (Facebook, Google, Apple) and triggers callbacks according to Figma design 1:565',
    (WidgetTester tester) async {
      bool facebookTapped = false;
      bool googleTapped = false;
      bool appleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AuthSocialLoginRowWidget(
                onFacebookTap: () => facebookTapped = true,
                onGoogleTap: () => googleTapped = true,
                onAppleTap: () => appleTapped = true,
              ),
            ),
          ),
        ),
      );

      // Verify 3 AuthSocialButtonWidget buttons are rendered
      expect(find.byType(AuthSocialButtonWidget), findsNWidgets(3));

      // Tap Facebook button (first button)
      await tester.tap(find.byType(AuthSocialButtonWidget).at(0));
      await tester.pump();
      expect(facebookTapped, isTrue);

      // Tap Google button (second button)
      await tester.tap(find.byType(AuthSocialButtonWidget).at(1));
      await tester.pump();
      expect(googleTapped, isTrue);

      // Tap Apple button (third button)
      await tester.tap(find.byType(AuthSocialButtonWidget).at(2));
      await tester.pump();
      expect(appleTapped, isTrue);
    },
  );
}
