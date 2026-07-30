import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_button.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/app_validators.dart';
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
  final otpController = TextEditingController();
  final otpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 50,
      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
        color: AppColors.white,
        fontFamily: LanguageHelper.englishFontFamily,
        fontWeight: FontWeight.bold,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.white, width: 2.0)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.prime, width: 2.5)),
      ),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.prime, width: 2.5)),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.onErrorLight, width: 2.5),
        ),
      ),
    );

    return AuthBackground(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) => previous.state != current.state,
        listener: (context, state) {
          if (state.state == StateType.success && state.otp.isNotEmpty) {
            context.pushNamed(Routes.createNewPasswordView, extra: cubit);
          } else if (state.state == StateType.error) {
            otpFormKey.currentState?.reset();
            otpController.clear();
          }
        },
        child: Form(
          key: otpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.forget_password_otp_code.tr(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.white,
                  fontFamily: LanguageHelper.englishFontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.forget_password_enter_otp_check_email.tr(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.white.withValues(alpha: 0.5),
                  fontFamily: LanguageHelper.englishFontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 15,
                    ),
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
                        Center(
                          child:
                              BlocBuilder<
                                ForgetPasswordCubit,
                                ForgetPasswordState
                              >(
                                builder: (context, state) {
                                  final isError =
                                      state.state == StateType.error;
                                  return Pinput(
                                    controller: otpController,
                                    length: 4,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    submittedPinTheme: submittedPinTheme,
                                    errorPinTheme: errorPinTheme,
                                    forceErrorState: isError,
                                    errorText: isError
                                        ? LocaleKeys
                                              .forget_password_invalid_otp_code
                                              .tr()
                                        : null,
                                    errorTextStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: AppColors.onErrorLight,
                                          fontFamily:
                                              LanguageHelper.englishFontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    validator: AppValidators.validateOtp,
                                  );
                                },
                              ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                          builder: (context, state) {
                            return CustomButton(
                              title: LocaleKeys.forget_password_confirm.tr(),
                              titleStyle: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                fontFamily: LanguageHelper.englishFontFamily,
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
                          },
                        ),
                        const SizedBox(height: 8),
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
                                  fontFamily: LanguageHelper.englishFontFamily,
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
                                    decorationColor: AppColors.prime,
                                    fontFamily:
                                        LanguageHelper.englishFontFamily,
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
