import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/shared/widgets/custom_text_field.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, BaseState<ProfileUIModel>>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _oldPasswordController,
                hint: LocaleKeys.profile_old_password.tr(),
                obscureText: _obscureOld,
                onToggleObscure: () {
                  setState(() => _obscureOld = !_obscureOld);
                },
                validator: (val) => val == null || val.isEmpty
                    ? LocaleKeys.validations_password_required.tr()
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _newPasswordController,
                hint: LocaleKeys.forget_password_new_password.tr(),
                obscureText: _obscureNew,
                onToggleObscure: () {
                  setState(() => _obscureNew = !_obscureNew);
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return LocaleKeys.validations_password_required.tr();
                  }
                  if (val.length < 8) {
                    return LocaleKeys.forget_password_password_at_least_8_characters.tr();
                  }
                  final hasUppercase = val.contains(RegExp(r'[A-Z]'));
                  final hasLowercase = val.contains(RegExp(r'[a-z]'));
                  final hasDigits = val.contains(RegExp(r'[0-9]'));
                  final hasSpecialCharacters =
                      val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                  if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
                    return LocaleKeys.validations_password_advanced_validation.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmPasswordController,
                hint: LocaleKeys.forget_password_confirm_password.tr(),
                obscureText: _obscureConfirm,
                onToggleObscure: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return LocaleKeys.validations_password_required.tr();
                  }
                  if (val != _newPasswordController.text) {
                    return LocaleKeys.validations_confirm_password_invalid.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: state.state == StateType.loading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<ProfileCubit>().doAction(
                            ChangePasswordEvent(
                              oldPassword: _oldPasswordController.text,
                              newPassword: _newPasswordController.text,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  disabledBackgroundColor:
                      AppColors.primaryOrange.withValues(alpha: 0.5),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: state.state == StateType.loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteFF,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        LocaleKeys.custom_widget_done.tr(),
                        style: 16.bold.copyWith(color: AppColors.whiteFF),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return CustomTextFormField(
      controller: controller,
      hintText: hint,
      isObscureText: obscureText,
      validator: validator,
      isDense: true,
      textStyle: 14.regular.copyWith(color: AppColors.whiteFF),
      hintStyle: 14.regular.copyWith(color: AppColors.whiteFF.withValues(alpha: 0.8)),
      prefixWidget: const Icon(
        Icons.lock_outline,
        color: AppColors.whiteFF,
        size: 20,
      ),
      suffixWidget: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.whiteFF,
          size: 20,
        ),
        onPressed: onToggleObscure,
      ),
      enableFill: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: AppColors.whiteFF, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: AppColors.whiteFF, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: AppColors.whiteFF, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }
}
