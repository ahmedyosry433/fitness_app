part of 'register_cubit.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

class RegisterSubmittedEvent extends RegisterEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const RegisterSubmittedEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}

class TogglePasswordVisibilityEvent extends RegisterEvent {
  const TogglePasswordVisibilityEvent();
}

class ToggleConfirmPasswordVisibilityEvent extends RegisterEvent {
  const ToggleConfirmPasswordVisibilityEvent();
}
