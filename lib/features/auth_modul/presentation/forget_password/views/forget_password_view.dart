import 'dart:ui';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/cubit/forget_password_cubit.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/intent/forget_password_intent.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/view_model/state/forget_password_state.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/auth_background.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_button.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
    final forgetFormKey = GlobalKey<FormState>();

    return AuthBackground(
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state.state == StateType.success) {
            context.pushNamed(Routes.otpVerificationView, extra: cubit);
          }
        },

        child: Form(
          key: forgetFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Your Email",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontFamily: 'RobotoEnglish',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Forget Password",
                style: TextStyle(
                  color: Colors.white,
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
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomAuthTextField(
                          controller: emailController,
                          hintText: "Email",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                          builder: (context, state) {
                            return CustomAuthButton(
                              title: "Sent OTP",
                              isLoading: state.state == StateType.loading,
                              onPressed: () {
                                if (forgetFormKey.currentState!.validate()) {
                                  cubit.doAction(
                                    SendOtpIntent(emailController.text),
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
      ),
    );
  }
}
