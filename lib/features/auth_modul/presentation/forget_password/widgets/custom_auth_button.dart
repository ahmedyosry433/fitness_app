// lib/features/auth_modul/presentation/forget_password/widgets/custom_auth_button.dart
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomAuthButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722), // البرتقالي المميز
          disabledBackgroundColor: const Color(
            0xFFFF5722,
          ).withValues(alpha: 0.5),
          backgroundColor: AppColors.prime,
          disabledBackgroundColor: AppColors.prime.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.white,
                  fontFamily: 'RobotoEnglish',
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
