import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/login_page.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/complete_register.dart';
import 'package:fitness/features/splash/onbord_page.dart';
import 'package:fitness/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: Routes.splash,
  navigatorKey: navigatorKey,
  routes: [
    _customAnimatedGoRoute(
      route: Routes.splash,
      page: (state, context) => const SplashPage(),
    ),
    _customAnimatedGoRoute(
      route: Routes.onBoard,
      page: (state, context) => const OnboardPage(),
    ),
    _customAnimatedGoRoute(
      route: Routes.login,
      page: (state, context) => const LoginPage(),
    ),
    _customAnimatedGoRoute(
      route: Routes.register,
      page: (state, context) => const CompleteRegisterPage(),
    ),
  ],
);

GoRoute _customAnimatedGoRoute({
  required String route,
  required Widget Function(GoRouterState state, BuildContext context) page,
  Duration duration = const Duration(milliseconds: 450),
  Offset beginOffset = const Offset(1, 0),
  Offset endOffset = Offset.zero,
  Curve curve = Curves.easeInOut,
  List<GoRoute> routes = const [],
}) => GoRoute(
  path: route,
  routes: routes,
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: page(state, context),
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: endOffset,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: child,
      );
    },
  ),
);
