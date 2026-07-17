import 'dart:ui';

import 'package:fitness/core/shared/widgets/global/text_field/global_text_field_theme.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:flutter/material.dart';

class AuthUiConfig {
  AuthUiConfig._();

  static const String backgroundImage = AppImages.authBackground;

  static const double cardBlurSigma = 17.3;
  static const double cardRadius = 50;
  static const double pillRadius = 20;
  static const double horizontalPadding = 16;
  static const double fieldSpacing = 16;
  static const double sectionSpacing = 24;
  static const double innerSectionSpacing = 8;

  static final ImageFilter cardBlurFilter = ImageFilter.blur(
    sigmaX: cardBlurSigma,
    sigmaY: cardBlurSigma,
    tileMode: TileMode.clamp,
  );

  static const double backgroundBlurSigma = 6.25;
  static const double logoWidth = 70;
  static const double logoHeight = 48;
  static const double logoTopOffset = 46;
  static const double socialIconSize = 32;
  static const double socialIconGap = 16;
  static const double fieldWidth = GlobalTextFieldTheme.fieldWidth;
  static const double fieldIconSize = GlobalTextFieldTheme.fieldIconSize;
  static const double fieldIconGap = GlobalTextFieldTheme.fieldIconGap;
  static const double orDividerWidth = 343;
  static const double orLineWidth = 80;
  static const double orLineGap = 20;
  static const double primaryButtonHeight = 40;

  static Color get screenOverlayColor =>
      const Color(0xFF1A1A1A).withValues(alpha: 0.5);

  static Color get cardFillColor =>
      const Color(0xFF242424).withValues(alpha: 0.1);

  static Color get fieldBorderColor => GlobalTextFieldTheme.fieldBorderColor;

  static Color get fieldHintColor => GlobalTextFieldTheme.fieldHintColor;

  static TextStyle get greetingLightStyle =>
      18.regular.copyWith(color: AppColors.white, height: 1.4);

  static TextStyle get greetingBoldStyle => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: AppTextStyles.fontFamily,
        color: AppColors.white,
        height: 1.4,
      );

  static TextStyle get cardTitleStyle => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        fontFamily: AppTextStyles.fontFamily,
        color: AppColors.white,
        height: 1.4,
      );

  static TextStyle get fieldHintStyle => GlobalTextFieldTheme.hintStyle;

  static TextStyle get fieldTextStyle => GlobalTextFieldTheme.textStyle;

  static TextStyle get linkStyle => 12.regular.copyWith(
        color: AppColors.fitnessOrange,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.fitnessOrange,
        height: 1.4,
      );

  static TextStyle get footerPrefixStyle =>
      14.regular.copyWith(color: AppColors.white, height: 1.4);

  static TextStyle get footerActionStyle => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        fontFamily: AppTextStyles.fontFamily,
        color: AppColors.fitnessOrangeAccent,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.fitnessOrangeAccent,
        height: 1.4,
      );

  static TextStyle get orLabelStyle =>
      12.regular.copyWith(color: fieldHintColor, height: 1.4);

  static TextStyle get primaryButtonTextStyle => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        fontFamily: AppTextStyles.fontFamily,
        color: AppColors.white,
      );
}
