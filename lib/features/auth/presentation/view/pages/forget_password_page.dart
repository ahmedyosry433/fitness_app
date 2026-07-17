import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/features/auth/presentation/view/widgets/forget_password_body_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/forget_password/forget_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordCubit>(),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  const _ForgetPasswordView();

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  StreamSubscription<ForgetPasswordNavigation>? _navigationSub;

  @override
  void initState() {
    super.initState();
    _navigationSub = context
        .read<ForgetPasswordCubit>()
        .navigationStream
        .listen(_handleNavigation);
  }

  void _handleNavigation(ForgetPasswordNavigation navigation) {
    switch (navigation) {
      case ForgetPasswordSuccessNavigation():
        CustomToast(
          context: context,
          header: LocaleKeys.auth_forget_success.tr(),
        ).showToast();
        context.go(Routes.login);
      case ForgetPasswordShowErrorNavigation(:final message):
        CustomToast(
          context: context,
          header: message,
          type: ToastificationType.error,
        ).showToast();
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ForgetPasswordCubit>().doAction(
          ForgetPasswordSubmittedEvent(email: _emailController.text.trim()),
        );
  }

  @override
  void dispose() {
    _navigationSub?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForgetPasswordBodyWidget(
      formKey: _formKey,
      emailController: _emailController,
      onSubmit: _submit,
      onBackToLogin: () => context.go(Routes.login),
      emailValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_email_required.tr();
        }
        if (!value.contains('@')) {
          return LocaleKeys.validations_email_invalid.tr();
        }
        return null;
      },
    );
  }
}
