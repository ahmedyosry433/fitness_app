import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/features/auth/presentation/view/widgets/login_body_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription<LoginNavigation>? _navigationSub;

  @override
  void initState() {
    super.initState();
    _navigationSub = context
        .read<LoginCubit>()
        .navigationStream
        .listen(_handleNavigation);
  }

  void _handleNavigation(LoginNavigation navigation) {
    switch (navigation) {
      case LoginSuccessNavigation():
        CustomToast(
          context: context,
          header: LocaleKeys.auth_login_success.tr(),
        ).showToast();
      case LoginShowErrorNavigation(:final message):
        CustomToast(
          context: context,
          header: message,
          type: ToastificationType.error,
        ).showToast();
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().doAction(
          LoginSubmittedEvent(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _navigationSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginBodyWidget(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      onLogin: _submit,
      onForgetPassword: () => context.push(Routes.forgetPassword),
      onRegister: () => context.push(Routes.register),
      emailValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_email_required.tr();
        }
        if (!value.contains('@')) {
          return LocaleKeys.validations_email_invalid.tr();
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.validations_password_required.tr();
        }
        return null;
      },
    );
  }
}
