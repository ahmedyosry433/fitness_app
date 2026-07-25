import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import '../../../../../../config/base_state/base_state.dart';

class ForgetPasswordState extends BaseState<AuthCommonResponse> {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  const ForgetPasswordState({
    super.state, // initial, loading, success, error
    super.data,
    super.errorMessage,
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
  });

  const ForgetPasswordState.initial()
    : email = '',
      otp = '',
      newPassword = '',
      confirmPassword = '',
      super.initial();

  ForgetPasswordState copyWith({
    StateType? state,
    AuthCommonResponse? data,
    String? errorMessage,
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
  }) {
    return ForgetPasswordState(
      state: state ?? this.state,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    super.props,
    email,
    otp,
    newPassword,
    confirmPassword,
  ];
}
