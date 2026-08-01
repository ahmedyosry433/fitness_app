import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';

class AppValidators {
  static String? validateRequired(String? val) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.validations_password_required.tr(); // Reusing string as fallback
    }
    return null;
  }

  static String? validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.validations_email_required.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(val)) {
      return LocaleKeys.validations_email_invalid.tr();
    }
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.validations_password_required.tr();
    }
    if (val.length < 8) {
      return LocaleKeys.forget_password_password_requirements.tr();
    }
    final hasUppercase = val.contains(RegExp(r'[A-Z]'));
    final hasLowercase = val.contains(RegExp(r'[a-z]'));
    final hasDigits = val.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters =
        val.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return LocaleKeys.validations_password_advanced_validation.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? val, String originalPassword) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.validations_password_required.tr();
    }
    if (val != originalPassword) {
      return LocaleKeys.validations_confirm_password_invalid.tr();
    }
    return null;
  }
}
