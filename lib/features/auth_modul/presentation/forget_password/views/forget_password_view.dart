import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_button.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/auth_background.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_text_field.dart';
import 'package:fitness/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final emailController = TextEditingController();
  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();

    return AuthBackground(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state.state == StateType.success) {
            context.pushNamed(Routes.otpVerificationView, extra: cubit);
          }
        },

        child: Form(
          key: _forgetFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.forget_password_enter_your_email.tr(),
                style: TextStyle(
                  color: AppColors.blackCE,
                  fontSize: 14,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.forget_password,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 25),
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.08),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomAuthTextField(
                          controller: emailController,
                          hintText: LocaleKeys.forget_password_email.tr(),
                          prefixIcon: SvgPicture.asset(Assets.icons.mail),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return LocaleKeys.forget_password_enter_your_email
                                  .tr();
                            }
                            if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value)) {
                              return LocaleKeys
                                  .forget_password_please_enter_valid_email
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BlocSelector<
                          ForgetPasswordCubit,
                          ForgetPasswordState,
                          StateType?
                        >(
                          selector: (state) => state.state,
                          builder: (context, stateType) {
                            return CustomButton(
                              title: "Sent OTP",
                              titleStyle: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'RobotoEnglish',
                              ),
                              isLoading: stateType == StateType.loading,
                              onTap: () {
                                if (_forgetFormKey.currentState!.validate()) {
                                  cubit.doAction(
                                    SendOtpIntent(emailController.text),
                                  );
                                }
                              },
                            );
                            // return CustomAuthButton(
                            //   title: "Sent OTP",
                            //   isLoading: stateType == StateType.loading,
                            //   onPressed: () {
                            //     if (_forgetFormKey.currentState!.validate()) {
                            //       cubit.doAction(
                            //         SendOtpIntent(emailController.text),
                            //       );
                            //     }
                            //   },
                            // );
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
      ),
    );
  }
}
