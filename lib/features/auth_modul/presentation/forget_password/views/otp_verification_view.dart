import 'dart:ui';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/auth_background.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_button.dart';
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
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFFFF5722), width: 1.5),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent, width: 1.5),
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
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Enter Your OTP Check Your Email",
                style: TextStyle(
                  color: Colors.white60,
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
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
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
                                    errorText:
                                        "Invalid OTP code, please try again",
                                    errorTextStyle: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                    onChanged: (value) {
                                      if (isOtpInvalid) {
                                        setState(() => isOtpInvalid = false);
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
                            return CustomAuthButton(
                              title: "Confirm",
                              isLoading: state.state == StateType.loading,
                              onPressed: () {
                                if (otpFormKey.currentState!.validate()) {
                                  cubit.doAction(
                                    VerifyOtpIntent(otpController.text),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Didn't Receive Verification Code?",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                  fontFamily: 'RobotoEnglish',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  cubit.doAction(ResendOtpIntent());
                                },
                                child: const Text(
                                  "Resend Code?",
                                  style: TextStyle(
                                    color: Color(0xFFFF5722),
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
