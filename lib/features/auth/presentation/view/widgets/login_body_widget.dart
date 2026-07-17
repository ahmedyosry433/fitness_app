import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/global/text_field/email_field.dart';
import 'package:fitness/core/shared/widgets/global/text_field/password_field.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_footer_link_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_glass_card_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_greeting_header_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_or_divider_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_primary_button_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_scaffold_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_social_login_row_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/auth_social_provider.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginBodyWidget extends StatelessWidget {
  const LoginBodyWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onForgetPassword,
    required this.onRegister,
    this.emailValidator,
    this.passwordValidator,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onForgetPassword;
  final VoidCallback onRegister;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? passwordValidator;

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldWidget(
      showTopLogo: true,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                top: AuthUiConfig.logoTopOffset +
                    AuthUiConfig.logoHeight +
                    24,
                bottom: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AuthUiConfig.horizontalPadding,
                      ),
                      child: AuthGreetingHeaderWidget(
                        greeting: LocaleKeys.auth_hey_there.tr(),
                        headline: LocaleKeys.auth_welcome_back_caps.tr(),
                      ),
                    ),
                    const SizedBox(height: AuthUiConfig.innerSectionSpacing),
                    AuthGlassCardWidget(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.auth_login.tr(),
                              textAlign: TextAlign.center,
                              style: AuthUiConfig.cardTitleStyle,
                            ),
                            const SizedBox(height: AuthUiConfig.sectionSpacing),
                            Column(
                              children: [
                                EmailField(
                                  controller: emailController,
                                  hintText: LocaleKeys.auth_email.tr(),
                                  validator: emailValidator,
                                ),
                                const SizedBox(height: AuthUiConfig.fieldSpacing),
                                BlocSelector<LoginCubit, LoginState, bool>(
                                  selector: (state) => state.isPasswordHidden,
                                  builder: (context, isPasswordHidden) {
                                    return PasswordField(
                                      controller: passwordController,
                                      hintText: LocaleKeys.auth_password.tr(),
                                      isObscure: isPasswordHidden,
                                      onToggleVisibility: () => context
                                          .read<LoginCubit>()
                                          .doAction(
                                            const TogglePasswordVisibilityEvent(),
                                          ),
                                      validator: passwordValidator,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: AuthUiConfig.innerSectionSpacing,
                                ),
                                AuthTextLinkWidget(
                                  label: LocaleKeys.auth_forget_password_question
                                      .tr(),
                                  onTap: onForgetPassword,
                                ),
                              ],
                            ),
                            const SizedBox(height: AuthUiConfig.sectionSpacing),
                            Center(
                              child: AuthOrDividerWidget(
                                label: LocaleKeys.auth_or.tr(),
                              ),
                            ),
                            const SizedBox(height: AuthUiConfig.sectionSpacing),
                            AuthSocialLoginRowWidget(
                              onFacebookTap: () => context
                                  .read<LoginCubit>()
                                  .doAction(
                                    const SocialLoginEvent(
                                      AuthSocialProvider.facebook,
                                    ),
                                  ),
                              onGoogleTap: () => context
                                  .read<LoginCubit>()
                                  .doAction(
                                    const SocialLoginEvent(
                                      AuthSocialProvider.google,
                                    ),
                                  ),
                              onAppleTap: () => context
                                  .read<LoginCubit>()
                                  .doAction(
                                    const SocialLoginEvent(
                                      AuthSocialProvider.apple,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: AuthUiConfig.sectionSpacing),
                            BlocSelector<LoginCubit, LoginState, bool>(
                              selector: (state) =>
                                  state.loginState.state == StateType.loading,
                              builder: (context, isLoading) {
                                return AuthPrimaryButtonWidget(
                                  label: LocaleKeys.auth_login.tr(),
                                  isLoading: isLoading,
                                  onPressed: onLogin,
                                );
                              },
                            ),
                            const SizedBox(height: AuthUiConfig.sectionSpacing),
                            AuthFooterLinkWidget(
                              prefix: LocaleKeys.auth_dont_have_account_yet.tr(),
                              actionLabel: LocaleKeys.auth_register.tr(),
                              onTap: onRegister,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
