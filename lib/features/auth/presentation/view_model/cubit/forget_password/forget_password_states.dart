part of 'forget_password_cubit.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<void> submitState;

  const ForgetPasswordState({
    this.submitState = const BaseState.initial(),
  });

  ForgetPasswordState copyWith({BaseState<void>? submitState}) =>
      ForgetPasswordState(submitState: submitState ?? this.submitState);

  @override
  List<Object?> get props => [submitState];
}
