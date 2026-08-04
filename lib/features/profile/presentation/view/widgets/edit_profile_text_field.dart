import 'package:flutter/material.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';

class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool enabled;
  final String? Function(String?)? validator;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black32.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.whiteFF.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: validator,
        style: 14.regular.copyWith(color: AppColors.whiteFF),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: 14.regular.copyWith(color: AppColors.grayA6),
          prefixIcon: Icon(icon, color: AppColors.grayA6, size: 20),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
