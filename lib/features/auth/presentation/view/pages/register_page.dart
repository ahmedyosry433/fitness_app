import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/features/auth/data/models/complete_register_params.dart';
import 'package:fitness/features/auth/presentation/view/widgets/register_body_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription<RegisterNavigation>? _navigationSub;

  @override
  void initState() {
    super.initState();
    _navigationSub = context.read<RegisterCubit>().navigationStream.listen(
      _handleNavigation,
    );
  }

  void _handleNavigation(RegisterNavigation navigation) {
    switch (navigation) {
      case RegisterSuccessNavigation():
        CustomToast(
          context: context,
          header: LocaleKeys.auth_register_success.tr(),
        ).showToast();
        context.pop();
      case RegisterSocialProfileRequiredNavigation(:final socialData):
        context.push(Routes.completeRegister, extra: socialData);
      case RegisterSocialSignedInNavigation():
        CustomToast(
          context: context,
          header: LocaleKeys.auth_login_success.tr(),
        ).showToast();
        context.go(Routes.home);
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

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    context.push(
      Routes.completeRegister,
      extra: CompleteRegisterParams(
        firstName: firstName,
        lastName: lastName.isEmpty ? 'Tech' : lastName,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rePassword: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _navigationSub?.cancel();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterBodyWidget(
      formKey: _formKey,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      emailController: _emailController,
      passwordController: _passwordController,
      onRegister: _submit,
      onLogin: () => context.pop(),
      firstNameValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_first_name_required.tr();
        }
        return null;
      },
      lastNameValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.validations_last_name_required.tr();
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
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.validations_password_required.tr();
        }
        return null;
      },
    );
  }
}
