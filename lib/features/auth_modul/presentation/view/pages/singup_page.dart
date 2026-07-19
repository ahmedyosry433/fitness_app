import 'dart:async';
import 'dart:ui';

import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/auth_background.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_button.dart';
import 'package:fitness/features/auth_modul/presentation/forget_password/widgets/custom_auth_text_field.dart';
import 'package:fitness/features/auth_modul/presentation/signup/view_model/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  StreamSubscription<SignUpNavigation>? _navigationSub;

  @override
  void initState() {
    super.initState();
    _navigationSub = context
        .read<SignUpCubit>()
        .navigationStream
        .listen(_handleNavigation);
  }

  void _handleNavigation(SignUpNavigation navigation) {
    switch (navigation) {
      case SignUpSuccessNavigation(:final response):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?.message ?? "Account created successfully"),
            backgroundColor: Colors.green,
          ),
        );
        context.go(Routes.login);
      case SignUpShowErrorNavigation(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SignUpCubit>().doAction(
          SignUpSubmittedEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _navigationSub?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                fontFamily: 'RobotoEnglish',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Sign Up",
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
                        controller: _nameController,
                        hintText: "Full Name",
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomAuthTextField(
                        controller: _emailController,
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
                      const SizedBox(height: 16),
                      CustomAuthTextField(
                        controller: _phoneController,
                        hintText: "Phone Number",
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomAuthTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomAuthTextField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          return CustomAuthButton(
                            title: "Sign Up",
                            isLoading:
                                state.signUpState.state == StateType.loading,
                            onPressed: _submit,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                              fontFamily: 'RobotoEnglish',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(Routes.login),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFFFF5722),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoEnglish',
                              ),
                            ),
                          ),
                        ],
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
