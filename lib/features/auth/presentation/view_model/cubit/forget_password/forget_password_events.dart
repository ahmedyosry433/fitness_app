part of 'forget_password_cubit.dart';

sealed class ForgetPasswordEvent {
  const ForgetPasswordEvent();
}

class ForgetPasswordSubmittedEvent extends ForgetPasswordEvent {
  final String email;

  const ForgetPasswordSubmittedEvent({required this.email});
}
