import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/views/create_new_password_view.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/views/forget_password_view.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/views/otp_verification_view.dart';
import 'package:fitness/features/auth_modul/presentation/signup/view_model/cubit/signup_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/singup_page.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/login_page.dart';
import 'package:fitness/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: Routes.register,
  navigatorKey: navigatorKey,
  routes: [
    _customAnimatedGoRoute(
      route: Routes.splash,
      page: (state, context) => const SplashPage(),
    ),
    _customAnimatedGoRoute(
      route: Routes.login,
      page: (state, context) => const LoginPage(),
    ),
    _customAnimatedGoRoute(
      route: Routes.register,
      page: (state, context) => BlocProvider(
        create: (context) => getIt<SignUpCubit>(),
        child: const SignUpView(),
      ),
    ),
    _customAnimatedGoRoute(
      route: Routes.forgetPassword,
      page: (state, context) => BlocProvider(
        create: (context) => getIt<ForgetPasswordCubit>(),
        child: ForgetPasswordView(),
      ),
    ),
    _customAnimatedGoRoute(
      route: Routes.otpVerificationView,
      page: (state, context) {
        final cubit = state.extra as ForgetPasswordCubit;
        return BlocProvider.value(value: cubit, child: OtpVerificationView());
      },
    ),
    _customAnimatedGoRoute(
      route: Routes.createNewPasswordView,
      page: (state, context) {
        final cubit = state.extra as ForgetPasswordCubit;
        return BlocProvider.value(
          value: cubit,
          child: const CreateNewPasswordView(),
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
  name: route,
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
