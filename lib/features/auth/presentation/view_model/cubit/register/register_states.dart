part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final BaseState<AuthUserEntity> registerState;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;

  const RegisterState({
    this.registerState = const BaseState.initial(),
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
  });

  RegisterState copyWith({
    BaseState<AuthUserEntity>? registerState,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
  }) =>
      RegisterState(
        registerState: registerState ?? this.registerState,
        isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
        isConfirmPasswordHidden:
            isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      );

  @override
  List<Object?> get props =>
      [registerState, isPasswordHidden, isConfirmPasswordHidden];
}
