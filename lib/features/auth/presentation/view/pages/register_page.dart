import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';

import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/features/auth/presentation/view/widgets/register_body_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  StreamSubscription<RegisterNavigation>? _navigationSub;

  @override
  void initState() {
    super.initState();
    _navigationSub = context
        .read<RegisterCubit>()
        .navigationStream
        .listen(_handleNavigation);
  }

  void _handleNavigation(RegisterNavigation navigation) {
    switch (navigation) {
      case RegisterSuccessNavigation():
        CustomToast(
          context: context,
          header: LocaleKeys.auth_register_success.tr(),
        ).showToast();
        context.pop();
      case RegisterShowErrorNavigation(:final message):
        CustomToast(
          context: context,
          header: message,
          type: ToastificationType.error,
        ).showToast();
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegisterCubit>().doAction(
          RegisterSubmittedEvent(
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
    return RegisterBodyWidget(
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      phoneController: _phoneController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      onRegister: _submit,
      onLogin: () => context.pop(),
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
