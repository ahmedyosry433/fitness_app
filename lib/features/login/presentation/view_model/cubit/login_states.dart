part of 'login_cubit.dart';

class LoginState extends Equatable {
  final BaseState<AuthUserEntity> loginState;
  final bool isPasswordHidden;

  const LoginState({
    this.loginState = const BaseState.initial(),
    this.isPasswordHidden = true,
  });

  LoginState copyWith({
    BaseState<AuthUserEntity>? loginState,
    bool? isPasswordHidden,
  }) =>
      LoginState(
        loginState: loginState ?? this.loginState,
        isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      );

  @override
  List<Object?> get props => [loginState, isPasswordHidden];
}
