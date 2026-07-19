import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/global/text_field/email_field.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_glass_card_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_greeting_header_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_primary_button_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_scaffold_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_top_logo_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/forget_password/forget_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgetPasswordBodyWidget extends StatelessWidget {
  const ForgetPasswordBodyWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onSubmit,
    required this.onBackToLogin,
    this.emailValidator,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;
  final String? Function(String?)? emailValidator;

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldWidget(
      showBackButton: true,
      onBack: onBackToLogin,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AuthUiConfig.horizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const AuthTopLogoWidget(),
              const SizedBox(height: 20),
              AuthGreetingHeaderWidget(
                greeting: LocaleKeys.auth_hey_there.tr(),
                headline: LocaleKeys.auth_forget_title.tr(),
              ),
              const SizedBox(height: 16),
              AuthGlassCardWidget(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.auth_forget_title.tr(),
                        textAlign: TextAlign.center,
                        style: AuthUiConfig.cardTitleStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.auth_forget_subtitle.tr(),
                        textAlign: TextAlign.center,
                        style: AuthUiConfig.fieldHintStyle,
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      EmailField(
                        controller: emailController,
                        hintText: LocaleKeys.auth_email.tr(),
                        validator: emailValidator,
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      BlocSelector<ForgetPasswordCubit, ForgetPasswordState,
                          bool>(
                        selector: (state) =>
                            state.submitState.state == StateType.loading,
                        builder: (context, isLoading) {
                          return AuthPrimaryButtonWidget(
                            label: LocaleKeys.auth_continue.tr(),
                            isLoading: isLoading,
                            onPressed: onSubmit,
                          );
                        },
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      Center(
                        child: TextButton(
                          onPressed: onBackToLogin,
                          child: Text(
                            LocaleKeys.auth_back_to_login.tr(),
                            style: AuthUiConfig.linkStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
