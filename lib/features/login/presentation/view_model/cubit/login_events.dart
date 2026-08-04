part of 'login_cubit.dart';

sealed class LoginEvent {
  const LoginEvent();
}

class LoginSubmittedEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmittedEvent({
    required this.email,
    required this.password,
  });
}

class TogglePasswordVisibilityEvent extends LoginEvent {
  const TogglePasswordVisibilityEvent();
}

class SocialLoginEvent extends LoginEvent {
  final AuthSocialProvider provider;

  const SocialLoginEvent(this.provider);
}
