part of 'signup_cubit.dart';

class SignUpState extends Equatable {
  final BaseState<AuthCommonResponse> signUpState;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;

  const SignUpState({
    this.signUpState = const BaseState.initial(),
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
  });

  SignUpState copyWith({
    BaseState<AuthCommonResponse>? signUpState,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
  }) =>
      SignUpState(
        signUpState: signUpState ?? this.signUpState,
        isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
        isConfirmPasswordHidden:
            isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      );

  @override
  List<Object?> get props =>
      [signUpState, isPasswordHidden, isConfirmPasswordHidden];
}
