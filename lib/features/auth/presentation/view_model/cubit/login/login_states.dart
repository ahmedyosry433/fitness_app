part of 'login_cubit.dart';

class LoginState extends Equatable {
  final BaseState<AuthUserEntity> loginState;
  final bool isPasswordHidden;
  final AuthSocialProvider? loadingSocialProvider;

  const LoginState({
    this.loginState = const BaseState.initial(),
    this.isPasswordHidden = true,
    this.loadingSocialProvider,
  });

  LoginState copyWith({
    BaseState<AuthUserEntity>? loginState,
    bool? isPasswordHidden,
    AuthSocialProvider? loadingSocialProvider,
    bool clearLoadingSocialProvider = false,
  }) => LoginState(
    loginState: loginState ?? this.loginState,
    isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    loadingSocialProvider: clearLoadingSocialProvider
        ? null
        : (loadingSocialProvider ?? this.loadingSocialProvider),
  );

  @override
  List<Object?> get props => [
    loginState, 
    isPasswordHidden,
    loadingSocialProvider,
  ];
}
