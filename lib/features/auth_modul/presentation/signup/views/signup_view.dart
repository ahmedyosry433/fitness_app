import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/features/auth_modul/presentation/signup/view_model/cubit/signup_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/signup/views/widgets/signup_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  StreamSubscription<SignUpNavigation>? _navigationSub;

  @override
  void initState() {
    super.initState();
    _navigationSub = context
        .read<SignUpCubit>()
        .navigationStream
        .listen(_handleNavigation);
  }

  void _handleNavigation(SignUpNavigation navigation) {
    switch (navigation) {
      case SignUpSuccessNavigation(:final response):
        CustomToast(
          context: context,
          header: response?.message ?? LocaleKeys.auth_register_success.tr(),
        ).showToast();
        context.go(Routes.login);
      case SignUpShowErrorNavigation(:final message):
        CustomToast(
          context: context,
          header: message,
          type: ToastificationType.error,
        ).showToast();
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SignUpCubit>().doAction(
          SignUpSubmittedEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _navigationSub?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignUpBodyWidget(
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      phoneController: _phoneController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      onRegister: _submit,
      onLogin: () => context.go(Routes.login),
      nameValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_name_required.tr();
        }
        return null;
      },
      emailValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_email_required.tr();
        }
        if (!value.contains('@')) {
          return LocaleKeys.validations_email_invalid.tr();
        }
        return null;
      },
      phoneValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_phone_required.tr();
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.validations_password_required.tr();
        }
        return null;
      },
      confirmPasswordValidator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.validations_confirm_password.tr();
        }
        if (value != _passwordController.text) {
          return LocaleKeys.validations_confirm_password_invalid.tr();
        }
        return null;
      },
    );
  }
}
