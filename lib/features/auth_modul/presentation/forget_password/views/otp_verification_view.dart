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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  bool isOtpInvalid = false;
  final otpController = TextEditingController();
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    final otpFormKey = GlobalKey<FormState>();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.15)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.prime, width: 1.5),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.onErrorLight, width: 1.5),
      ),
    );

    return AuthBackground(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) => previous.state != current.state,
        listener: (context, state) {
          if (state.state == StateType.success && state.otp.isNotEmpty) {
            setState(() => isOtpInvalid = false);
            context.pushNamed(Routes.createNewPasswordView, extra: cubit);
          } else if (state.state == StateType.error) {
            setState(() {
              isOtpInvalid = true;
            });
            otpFormKey.currentState?.reset();
          }
        },
        child: Form(
          key: otpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "OTP CODE",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.forget_password_enter_otp_check_email.tr(),
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 40),

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
                      children: [
                        Center(
                          child:
                              BlocBuilder<
                                ForgetPasswordCubit,
                                ForgetPasswordState
                              >(
                                builder: (context, state) {
                                  if (state.state == StateType.error) {
                                    otpController.clear();
                                  }
                                  return Pinput(
                                    key: ValueKey('pinput_error_$isOtpInvalid'),
                                    controller: otpController,
                                    length: 4,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    errorPinTheme: errorPinTheme,
                                    forceErrorState: isOtpInvalid,
                                    errorText: LocaleKeys
                                        .forget_password_invalid_otp_code
                                        .tr(),
                                    errorTextStyle: const TextStyle(
                                      color: AppColors.onErrorLight,
                                      fontSize: 12,
                                    ),
                                    onChanged: (value) {
                                      if (isOtpInvalid) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              if (mounted) {
                                                setState(() {
                                                  isOtpInvalid = false;
                                                });
                                              }
                                            });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.length < 4) {
                                        return "Please enter the complete 4-digit code";
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                        ),
                        const SizedBox(height: 40),
                        BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                          builder: (context, state) {
                            return CustomButton(
                              title: LocaleKeys.forget_password_confirm.tr(),
                              titleStyle: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'RobotoEnglish',
                              ),
                              isLoading: state.state == StateType.loading,
                              onTap: () {
                                if (otpFormKey.currentState!.validate()) {
                                  cubit.doAction(
                                    VerifyOtpIntent(otpController.text),
                                  );
                                }
                              },
                            );
                            // return CustomAuthButton(
                            //   title: LocaleKeys.forget_password_confirm.tr(),
                            //   isLoading: state.state == StateType.loading,
                            //   onPressed: () {
                            //     if (otpFormKey.currentState!.validate()) {
                            //       cubit.doAction(
                            //         VerifyOtpIntent(otpController.text),
                            //       );
                            //     }
                            //   },
                            // );
                          },
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                LocaleKeys.forget_password_didnt_receive_code
                                    .tr(),
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontFamily: 'RobotoEnglish',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  cubit.doAction(ResendOtpIntent());
                                },
                                child: Text(
                                  LocaleKeys.forget_password_resend_code.tr(),
                                  style: TextStyle(
                                    color: AppColors.prime,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'RobotoEnglish',
                                  ),
                                ),
                              ),
                            ],
                          ),
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
