import 'package:fitness/config/base_event/base_event.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/features/auth_modul/data/models/request/verify_otp_request.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/models/request/forget_password_request.dart';
import '../../../../data/models/request/reset_password_request.dart';
import '../../../../domain/use_cases/forget_password_use_case.dart';
import '../../../../domain/use_cases/verify_otp_use_case.dart';
import '../../../../domain/use_cases/reset_password_use_case.dart';
import '../intent/forget_password_intent.dart';
import '../state/forget_password_state.dart';
import '../../../../../../config/base_state/base_state.dart';

@injectable
class ForgetPasswordCubit
    extends BaseCubit<ForgetPasswordState, ForgetPasswordIntent, BaseEvent> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgetPasswordCubit(
    this._forgetPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
  ) : super(const ForgetPasswordState.initial());

  @override
  Future<void> doAction(ForgetPasswordIntent event) async {
    if (event is SendOtpIntent) {
      await _executeSendOtp(event.email);
    } else if (event is VerifyOtpIntent) {
      await _executeVerifyOtp(event.otp);
    } else if (event is ResendOtpIntent) {
      await _executeResendOtp();
    } else if (event is ResetPasswordSubmitIntent) {
      await _executeResetPassword(event.newPassword, event.confirmPassword);
    }
  }

  Future<void> _executeSendOtp(String email) async {
    emit(state.copyWith(state: StateType.loading, errorMessage: null));

    final request = ForgetPasswordRequest(email: email.trim());
    final result = await _forgetPasswordUseCase(request);

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            state: StateType.success,
            data: response,
            email: email.trim(),
          ),
        );
        doNavigationAction(
          const ShowSuccessToastEvent("Verification code sent successfully"),
        );
        doNavigationAction(
          const NavigateEvent(routeName: Routes.otpVerificationView),
        );
      },
      error: (exception) {
        final errorMessage = exception.toString();
        emit(state.copyWith(state: StateType.error, errorMessage: errorMessage));
        doNavigationAction(ShowErrorToastEvent(errorMessage));
      },
    );
  }

  Future<void> _executeVerifyOtp(String otp) async {
    emit(state.copyWith(state: StateType.loading, errorMessage: null));

    final request = VerifyOtpRequest(email: state.email, otp: otp.trim());

    final result = await _verifyOtpUseCase(request);

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            state: StateType.success,
            data: response,
            otp: otp.trim(),
          ),
        );
        doNavigationAction(
          const ShowSuccessToastEvent("OTP verified successfully"),
        );
        doNavigationAction(
          const NavigateEvent(routeName: Routes.createNewPasswordView),
        );
      },
      error: (exception) {
        final errorMessage = exception.toString();
        emit(
          state.copyWith(state: StateType.error, errorMessage: errorMessage),
        );
        doNavigationAction(ShowErrorToastEvent(errorMessage));
      },
    );
  }

  Future<void> _executeResendOtp() async {
    emit(state.copyWith(state: StateType.loading, errorMessage: null));

    final request = ForgetPasswordRequest(email: state.email);
    final result = await _forgetPasswordUseCase(request);

    result.when(
      success: (response) {
        emit(state.copyWith(state: StateType.success, data: response));
        doNavigationAction(
          const ShowSuccessToastEvent("A new code has been sent to your email"),
        );
      },
      error: (exception) {
        final errorMessage = exception.toString();
        emit(
          state.copyWith(state: StateType.error, errorMessage: errorMessage),
        );
        doNavigationAction(ShowErrorToastEvent(exception.toString()));
      },
    );
  }

  Future<void> _executeResetPassword(
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      doNavigationAction(const ShowErrorToastEvent("Passwords do not match"));
      return;
    }

    emit(state.copyWith(state: StateType.loading, errorMessage: null));

    final request = ResetPasswordRequest(
      email: state.email,
      newPassword: password,
      otp: state.otp,
    );
    final result = await _resetPasswordUseCase(request);

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            state: StateType.success,
            data: response,
            newPassword: password,
            confirmPassword: confirmPassword,
          ),
        );
        doNavigationAction(
          const ShowSuccessToastEvent("Password updated successfully"),
        );
        doNavigationAction(const NavigateEvent(routeName: Routes.login));
      },
      error: (exception) {
        final errorMessage = exception.toString();
        emit(
          state.copyWith(state: StateType.error, errorMessage: errorMessage),
        );
        doNavigationAction(ShowErrorToastEvent(errorMessage));
      },
    );
  }
}
