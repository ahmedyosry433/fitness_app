import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/ai_agent/presentation/view/pages/ai_agent_page.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/login_page.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/complete_register.dart';
import 'package:fitness/features/exercise_module/presentation/view/pages/exercise_module_page.dart';
import 'package:fitness/features/splash/onbord_page.dart';
import 'package:fitness/features/splash/splash_page.dart';
import 'package:fitness/features/home/presentation/view/pages/home_page.dart';
import 'package:fitness/features/home/presentation/view/pages/main_scaffold.dart';
import 'package:fitness/features/workout/presentation/view/pages/workout_page.dart';
import 'package:fitness/features/profile/presentation/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/cubit/exercise_module_cubit.dart';
import 'package:fitness/features/exercise_module/presentation/view_model/exercise_intent.dart';
final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: Routes.home, // Open home directly to test bottom nav
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            _customAnimatedGoRoute(
              route: Routes.home,
              page: (state, context) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            _customAnimatedGoRoute(
              route: Routes.aiAgent,
              page: (state, context) => const AiAgentPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            _customAnimatedGoRoute(
              route: Routes.workout,
              page: (state, context) => const WorkoutPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            _customAnimatedGoRoute(
              route: Routes.profile,
              page: (state, context) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    _customAnimatedGoRoute(
      route: Routes.exercise,
      page: (state, context) {
        final extra = state.extra as Map<String, dynamic>?;
        final primeMoverMuscleId = extra?['primeMoverMuscleId'] ?? '69d982ef85f6bfa972bf2248';
        final pageTitle = extra?['pageTitle'] ?? '';
        final pageDescription = extra?['pageDescription'] ?? '';
        final backgroundImage = extra?['backgroundImage'] ?? '';

        return BlocProvider(
          create: (context) => getIt<ExerciseModuleCubit>()..processIntent(
            InitExerciseModuleIntent(
              primeMoverMuscleId: primeMoverMuscleId,
              pageTitle: pageTitle,
              pageDescription: pageDescription,
            )
          ),
          child: ExerciseModulePage(
            primeMoverMuscleId: primeMoverMuscleId,
            pageTitle: pageTitle,
            pageDescription: pageDescription,
            backgroundImage: backgroundImage,
          ),
        );
      },
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
