import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class GlobalTextFieldTheme {
  GlobalTextFieldTheme._();

  static const double fieldWidth = 311;
  static const double pillRadius = 26;
  static const double horizontalPadding = 16;
  static const double fieldIconSize = 20;
  static const double fieldIconGap = 8;

  static Color get fieldBorderColor => const Color(0xFFD9D9D9);

  static Color get fieldHintColor => const Color(0xFFD3D3D3);

  static TextStyle get hintStyle =>
      12.regular.copyWith(color: fieldHintColor, height: 1.4);

  static TextStyle get textStyle =>
      12.regular.copyWith(color: AppColors.white, height: 1.4);

  static InputDecoration decoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final borderRadius = BorderRadius.circular(pillRadius);
    final borderSide = BorderSide(color: fieldBorderColor);

    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      filled: false,
      isDense: true,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(
        minWidth: 44,
        minHeight: fieldIconSize,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(
        minWidth: 44,
        minHeight: fieldIconSize,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.redCC),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.redCC),
      ),
      errorStyle: hintStyle.copyWith(color: AppColors.redCC),
    );
  }
}
