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
import 'package:fitness/core/utils/app_validators.dart';

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

  late ValueNotifier<bool> _obscureOld;
  late ValueNotifier<bool> _obscureNew;
  late ValueNotifier<bool> _obscureConfirm;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _obscureOld = ValueNotifier<bool>(true);
    _obscureNew = ValueNotifier<bool>(true);
    _obscureConfirm = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _obscureOld.dispose();
    _obscureNew.dispose();
    _obscureConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _obscureOld,
            builder: (context, isObscure, child) {
              return CustomTextFormField(
                controller: _oldPasswordController,
                hintText: LocaleKeys.profile_old_password.tr(),
                isObscureText: isObscure,
                validator: AppValidators.validateRequired,
                isDense: true,
                textStyle: 14.regular.copyWith(color: AppColors.whiteFF),
                hintStyle: 14.regular.copyWith(
                  color: AppColors.whiteFF.withValues(alpha: 0.8),
                ),
                prefixWidget: const Icon(
                  Icons.lock_outline,
                  color: AppColors.whiteFF,
                  size: 20,
                ),
                suffixWidget: IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.whiteFF,
                    size: 20,
                  ),
                  onPressed: () => _obscureOld.value = !isObscure,
                ),
                enableFill: true,
                fillColor: Colors.transparent,
                borderColor: AppColors.whiteFF,
                focusBorderColor: AppColors.whiteFF,
                borderRadius: 50,
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _obscureNew,
            builder: (context, isObscure, child) {
              return CustomTextFormField(
                controller: _newPasswordController,
                hintText: LocaleKeys.forget_password_new_password.tr(),
                isObscureText: isObscure,
                validator: AppValidators.validatePassword,
                isDense: true,
                textStyle: 14.regular.copyWith(color: AppColors.whiteFF),
                hintStyle: 14.regular.copyWith(
                  color: AppColors.whiteFF.withValues(alpha: 0.8),
                ),
                prefixWidget: const Icon(
                  Icons.lock_outline,
                  color: AppColors.whiteFF,
                  size: 20,
                ),
                suffixWidget: IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.whiteFF,
                    size: 20,
                  ),
                  onPressed: () => _obscureNew.value = !isObscure,
                ),
                enableFill: true,
                fillColor: Colors.transparent,
                borderColor: AppColors.whiteFF,
                focusBorderColor: AppColors.whiteFF,
                borderRadius: 50,
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _obscureConfirm,
            builder: (context, isObscure, child) {
              return CustomTextFormField(
                controller: _confirmPasswordController,
                hintText: LocaleKeys.forget_password_confirm_password.tr(),
                isObscureText: isObscure,
                validator: (val) => AppValidators.validateConfirmPassword(
                  val,
                  _newPasswordController.text,
                ),
                isDense: true,
                textStyle: 14.regular.copyWith(color: AppColors.whiteFF),
                hintStyle: 14.regular.copyWith(
                  color: AppColors.whiteFF.withValues(alpha: 0.8),
                ),
                prefixWidget: const Icon(
                  Icons.lock_outline,
                  color: AppColors.whiteFF,
                  size: 20,
                ),
                suffixWidget: IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.whiteFF,
                    size: 20,
                  ),
                  onPressed: () => _obscureConfirm.value = !isObscure,
                ),
                enableFill: true,
                fillColor: Colors.transparent,
                borderColor: AppColors.whiteFF,
                focusBorderColor: AppColors.whiteFF,
                borderRadius: 50,
              );
            },
          ),
          const SizedBox(height: 32),
          BlocSelector<ProfileCubit, ProfileState, bool>(
            selector: (state) =>
                state.changePasswordState.state == StateType.loading,
            builder: (context, isLoading) {
              return ElevatedButton(
                onPressed: isLoading
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
                  disabledBackgroundColor: AppColors.primaryOrange.withValues(
                    alpha: 0.5,
                  ),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: isLoading
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
              );
            },
          ),
        ],
      ),
    );
  }
}
