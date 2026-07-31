part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final BaseState<AuthUserEntity> registerState;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final AuthSocialProvider? loadingSocialProvider;

  const RegisterState({
    this.registerState = const BaseState.initial(),
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
    this.loadingSocialProvider,
  });

  RegisterState copyWith({
    BaseState<AuthUserEntity>? registerState,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    AuthSocialProvider? loadingSocialProvider,
    bool clearLoadingSocialProvider = false,
  }) => RegisterState(
    registerState: registerState ?? this.registerState,
    isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    isConfirmPasswordHidden:
        isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
    loadingSocialProvider: clearLoadingSocialProvider 
        ? null 
        : (loadingSocialProvider ?? this.loadingSocialProvider),
  );

  @override
  List<Object?> get props => [
    registerState,
    isPasswordHidden,
    isConfirmPasswordHidden,
    loadingSocialProvider,
  ];
}
