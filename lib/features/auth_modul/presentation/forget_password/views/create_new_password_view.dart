import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/shared/widgets/custom_button.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/app_validators.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/auth_background.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_text_field.dart';
import 'package:fitness/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    final resetFormKey = GlobalKey<FormState>();
    return AuthBackground(
      child: Form(
        key: resetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.forget_password_make_sure_8_characters_or_more.tr(),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.white.withValues(alpha: 0.5),
                fontFamily: LanguageHelper.englishFontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.forget_password_create_new_password.tr(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.white,
                fontFamily: LanguageHelper.englishFontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.08),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomAuthTextField(
                        controller: passwordController,
                        hintText: LocaleKeys.forget_password_password.tr(),
                        prefixIcon: SvgPicture.asset(Assets.icons.lock),
                        isPassword: true,
                        validator: AppValidators.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      CustomAuthTextField(
                        controller: confirmPasswordController,
                        hintText: LocaleKeys.forget_password_password.tr(),
                        prefixIcon: SvgPicture.asset(Assets.icons.lock),
                        isPassword: true,
                        validator: (value) => AppValidators.confirmPassword(
                          passwordController.text,
                          value,
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                        builder: (context, state) {
                          return CustomButton(
                            title: "Done",
                            titleStyle: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: AppColors.white,
                                  fontFamily: LanguageHelper.englishFontFamily,
                                  fontWeight: FontWeight.w900,
                                ),
                            isLoading: state.state == StateType.loading,
                            onTap: () {
                              if (resetFormKey.currentState!.validate()) {
                                cubit.doAction(
                                  ResetPasswordSubmitIntent(
                                    newPassword: passwordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
