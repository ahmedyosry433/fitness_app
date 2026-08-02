import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/meal_ref_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Regression tests for the Smart Coach meal card navigation.
///
/// The card used to push the unregistered path `/meal?id=<id>`, which produced
/// a go_router "no routes for location" screen, and the details route read the
/// id from `extra` only - so a query parameter would have been ignored and the
/// hardcoded fallback meal was opened instead.
void main() {
  late String? pushedLocation;
  late Object? pushedExtra;

  Widget buildSubject({required String id}) {
    pushedLocation = null;
    pushedExtra = null;

    final router = GoRouter(
      initialLocation: Routes.aiAgent,
      routes: [
        GoRoute(
          path: Routes.aiAgent,
          builder: (context, state) => Scaffold(
            body: MealRefCard(id: id, name: 'Adana kebab'),
          ),
        ),
        GoRoute(
          path: Routes.detailsFood,
          builder: (context, state) {
            pushedLocation = state.matchedLocation;
            pushedExtra = state.extra;
            return const Scaffold(body: Text('details'));
          },
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('opens the food details route with the meal id in extra', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(id: '53262'));

    await tester.tap(find.byType(MealRefCard));
    await tester.pumpAndSettle();

    expect(pushedLocation, Routes.detailsFood);
    expect(pushedExtra, '53262');
    expect(find.text('details'), findsOneWidget);
  });

  testWidgets('does not fall back to a different meal', (tester) async {
    await tester.pumpWidget(buildSubject(id: '53085'));

    await tester.tap(find.byType(MealRefCard));
    await tester.pumpAndSettle();

    expect(pushedExtra, isNot('52959'));
    expect(pushedExtra, '53085');
  });
}
