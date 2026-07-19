import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth_modul/data/models/request/signup_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:fitness/features/auth_modul/domain/use_cases/signup_use_case.dart';
import 'package:injectable/injectable.dart';

part 'signup_events.dart';
part 'signup_navigation.dart';
part 'signup_states.dart';

@injectable
class SignUpCubit extends BaseCubit<SignUpState, SignUpEvent, SignUpNavigation> {
  SignUpCubit(this._signUpUseCase) : super(const SignUpState());

  final SignUpUseCase _signUpUseCase;

  @override
  Future<void> doAction(SignUpEvent event) async => switch (event) {
        SignUpSubmittedEvent() => _signUp(event),
        TogglePasswordVisibilityEvent() => _togglePassword(),
        ToggleConfirmPasswordVisibilityEvent() => _toggleConfirmPassword(),
      };

  Future<void> _signUp(SignUpSubmittedEvent event) async {
    if (state.signUpState.state == StateType.loading) return;

    if (event.password != event.confirmPassword) {
      doNavigationAction(
        const SignUpShowErrorNavigation("Passwords do not match"),
      );
      return;
    }

    emit(state.copyWith(signUpState: const BaseState.loading()));

    final request = SignUpRequest(
      name: event.name.trim(),
      email: event.email.trim(),
      phone: event.phone.trim(),
      password: event.password,
      rePassword: event.confirmPassword,
    );

    final result = await _signUpUseCase(request);

    result.when(
      success: (response) {
        emit(state.copyWith(signUpState: BaseState.success(response)));
        doNavigationAction(SignUpSuccessNavigation(response));
      },
      error: (exception) {
        emit(state.copyWith(signUpState: BaseState.error(exception)));
        if (exception != null) {
          doNavigationAction(
            SignUpShowErrorNavigation(exception.toString()),
          );
        }
      },
    );
  }

  void _togglePassword() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void _toggleConfirmPassword() {
    emit(
      state.copyWith(isConfirmPasswordHidden: !state.isConfirmPasswordHidden),
    );
  }
}
