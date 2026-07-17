import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:flutter/material.dart';

class AuthPrimaryButtonWidget extends StatelessWidget {
  const AuthPrimaryButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 311,
        height: AuthUiConfig.primaryButtonHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.fitnessOrange,
            disabledBackgroundColor:
                AppColors.fitnessOrange.withValues(alpha: 0.6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthUiConfig.pillRadius),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(label, style: AuthUiConfig.primaryButtonTextStyle),
        ),
      ),
    );
  }
}
