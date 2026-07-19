part of 'signup_cubit.dart';

sealed class SignUpEvent {
  const SignUpEvent();
}

class SignUpSubmittedEvent extends SignUpEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const SignUpSubmittedEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}

class TogglePasswordVisibilityEvent extends SignUpEvent {
  const TogglePasswordVisibilityEvent();
}

class ToggleConfirmPasswordVisibilityEvent extends SignUpEvent {
  const ToggleConfirmPasswordVisibilityEvent();
}

class SocialSignInSubmittedEvent extends SignUpEvent {
  final AuthSocialProvider provider;

  const SocialSignInSubmittedEvent(this.provider);
}
