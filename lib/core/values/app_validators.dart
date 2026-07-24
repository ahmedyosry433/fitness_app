import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';

abstract class AppValidators {
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return LocaleKeys.forget_password_enter_your_email.tr();
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email.trim())) {
      return LocaleKeys.forget_password_please_enter_valid_email.tr();
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return LocaleKeys.forget_password.tr();
    }

    if (password.length < 8) {
      return LocaleKeys.forget_password_make_sure_8_characters_or_more.tr();
    }

    if (!RegExp(
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$",
    ).hasMatch(password)) {
      return LocaleKeys.validations_confirm_password_invalid.tr();
    }

    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return LocaleKeys.validations_confirm_password.tr();
    }

    if (password != confirmPassword) {
      return LocaleKeys.validations_confirm_password_invalid.tr();
    }

    return null;
  }

  static String? validateOtp(String? otp) {
    if (otp == null || otp.trim().length < 4) {
      return "Please enter the complete 4-digit code";
    }
    return null;
  }

  // static String? validateEmptyTextFormField(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return LocaleKeys.empt.tr();
  //   }
  //   return null;
  // }
}
