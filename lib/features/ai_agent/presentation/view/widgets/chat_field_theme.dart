import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

/// Chat-only field styling, mirroring the shared `GlobalTextField` look
/// (pill border, 12/regular text, 44px icon slots) without pulling a whole
/// form-field library into this feature.
abstract final class ChatFieldTheme {
  static const double pillRadius = 26;
  static const double horizontalPadding = 16;
  static const double verticalPadding = 14;
  static const double iconSize = 20;
  static const double iconSlotWidth = 44;
  static const double attachmentPreviewSize = 72;

  static const Color borderColor = Color(0xFFD9D9D9);
  static const Color hintColor = Color(0xFFD3D3D3);

  static TextStyle get hintStyle =>
      12.regular.copyWith(color: hintColor, height: 1.4);

  static TextStyle get textStyle =>
      12.regular.copyWith(color: AppColors.white, height: 1.4);

  static InputDecoration decoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final borderRadius = BorderRadius.circular(pillRadius);
    const borderSide = BorderSide(color: borderColor);

    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      filled: false,
      isDense: true,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(
        minWidth: iconSlotWidth,
        minHeight: iconSize,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(
        minWidth: iconSlotWidth,
        minHeight: iconSize,
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
