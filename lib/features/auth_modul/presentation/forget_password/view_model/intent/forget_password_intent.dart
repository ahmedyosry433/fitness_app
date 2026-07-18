abstract class ForgetPasswordIntent {}

class SendOtpIntent extends ForgetPasswordIntent {
  final String email;
  SendOtpIntent(this.email);
}

class VerifyOtpIntent extends ForgetPasswordIntent {
  final String otp;
  VerifyOtpIntent(this.otp);
}

class ResendOtpIntent extends ForgetPasswordIntent {}

class ResetPasswordSubmitIntent extends ForgetPasswordIntent {
  final String newPassword;
  final String confirmPassword;
  ResetPasswordSubmitIntent({
    required this.newPassword,
    required this.confirmPassword,
  });
}
