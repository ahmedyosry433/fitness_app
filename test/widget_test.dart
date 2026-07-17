import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/app.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Provide a mock for SharedPreferences which is used by EasyLocalization
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    
    // Initialize dependency injection for the app
    configureDependencies();
  });

  testWidgets('FitnessApp full app smoke test (Splash Screen)', (WidgetTester tester) async {
    // Provide a physical size for ScreenUtil to initialize correctly in tests
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    // Build the app with EasyLocalization wrapper just like in main.dart
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [arabicLocale, englishLocale],
        fallbackLocale: arabicLocale,
        startLocale: englishLocale,
        path: assetsLocalization,
        child: const FitnessApp(),
      ),
    );

    // Let the first frame render (SplashPage)
    await tester.pump();
    
    // We should expect to see the FitnessApp in the widget tree
    expect(find.byType(FitnessApp), findsOneWidget);
    
    // We expect SplashPage to be rendered since it's the initial route
    // Splash page contains an Image widget for the logo
    expect(find.byType(Image), findsWidgets);
    
    // Fast-forward time by 4 seconds. 
    // This allows the Future.delayed and Timer in SplashPage to complete,
    // which triggers the navigation to OnboardPage and disposes the repeating animations.
    await tester.pump(const Duration(seconds: 4));
    
    // Pump another frame to finish the navigation transition
    await tester.pumpAndSettle();

    // Now we should be on the OnboardPage
    // (Optional: verify something on the OnboardPage if you want)

    // Reset view size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
