import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/global/text_field/email_field.dart';
import 'package:fitness/core/shared/widgets/global/text_field/global_text_field.dart';
import 'package:fitness/core/shared/widgets/global/text_field/password_field.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:fitness/core/values/field_assets.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_footer_link_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_glass_card_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_greeting_header_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_or_divider_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_primary_button_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_scaffold_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_social_login_row_widget.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_top_logo_widget.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/register/register_cubit.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBodyWidget extends StatelessWidget {
  const RegisterBodyWidget({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.onRegister,
    required this.onLogin,
    this.firstNameValidator,
    this.lastNameValidator,
    this.emailValidator,
    this.passwordValidator,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onRegister;
  final VoidCallback onLogin;
  final String? Function(String?)? firstNameValidator;
  final String? Function(String?)? lastNameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? passwordValidator;

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldWidget(
      showBackButton: true,
      onBack: onLogin,
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
                headline: LocaleKeys.auth_create_an_account.tr(),
              ),
              const SizedBox(height: 16),
              AuthGlassCardWidget(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.auth_register.tr(),
                        textAlign: TextAlign.center,
                        style: AuthUiConfig.cardTitleStyle,
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      GlobalTextField(
                        controller: firstNameController,
                        hintText: LocaleKeys.auth_first_name.tr(),
                        prefixIconAsset: FieldAssets.iconUser,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: firstNameValidator,
                      ),
                      const SizedBox(height: AuthUiConfig.fieldSpacing),
                      GlobalTextField(
                        controller: lastNameController,
                        hintText: LocaleKeys.auth_last_name.tr(),
                        prefixIconAsset: FieldAssets.iconUser,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: lastNameValidator,
                      ),
                      const SizedBox(height: AuthUiConfig.fieldSpacing),
                      EmailField(
                        controller: emailController,
                        hintText: LocaleKeys.auth_email.tr(),
                        validator: emailValidator,
                      ),
                      const SizedBox(height: AuthUiConfig.fieldSpacing),
                      BlocSelector<RegisterCubit, RegisterState, bool>(
                        selector: (state) => state.isPasswordHidden,
                        builder: (context, isPasswordHidden) {
                          return PasswordField(
                            controller: passwordController,
                            hintText: LocaleKeys.auth_password.tr(),
                            isObscure: isPasswordHidden,
                            onToggleVisibility: () =>
                                context.read<RegisterCubit>().doAction(
                                  const TogglePasswordVisibilityEvent(),
                                ),
                            validator: passwordValidator,
                          );
                        },
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      Center(
                        child: AuthOrDividerWidget(
                          label: LocaleKeys.auth_or.tr(),
                        ),
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      AuthSocialLoginRowWidget(
                        onFacebookTap: () =>
                            context.read<RegisterCubit>().doAction(
                              const SocialRegisterEvent(
                                AuthSocialProvider.facebook,
                              ),
                            ),
                        onGoogleTap: () =>
                            context.read<RegisterCubit>().doAction(
                              const SocialRegisterEvent(
                                AuthSocialProvider.google,
                              ),
                            ),
                        onAppleTap: () =>
                            context.read<RegisterCubit>().doAction(
                              const SocialRegisterEvent(
                                AuthSocialProvider.apple,
                              ),
                            ),
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      BlocSelector<RegisterCubit, RegisterState, bool>(
                        selector: (state) =>
                            state.registerState.state == StateType.loading,
                        builder: (context, isLoading) {
                          return AuthPrimaryButtonWidget(
                            label: LocaleKeys.auth_register.tr(),
                            isLoading: isLoading,
                            onPressed: onRegister,
                          );
                        },
                      ),
                      const SizedBox(height: AuthUiConfig.sectionSpacing),
                      AuthFooterLinkWidget(
                        prefix: LocaleKeys.auth_already_have_account.tr(),
                        actionLabel: LocaleKeys.auth_login.tr(),
                        onTap: onLogin,
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
