import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth/data/models/forgot_password_params.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

part 'forget_password_events.dart';
part 'forget_password_navigation.dart';
part 'forget_password_states.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState,
    ForgetPasswordEvent, ForgetPasswordNavigation> {
  ForgetPasswordCubit(this._authRepository) : super(const ForgetPasswordState());

  final AuthRepository _authRepository;

  @override
  Future<void> doAction(ForgetPasswordEvent event) async => switch (event) {
        ForgetPasswordSubmittedEvent() => _submit(event),
      };

  Future<void> _submit(ForgetPasswordSubmittedEvent event) async {
    if (state.submitState.state == StateType.loading) return;

    emit(state.copyWith(submitState: const BaseState.loading()));

    final result = await _authRepository.forgotPassword(
      params: ForgotPasswordParams(email: event.email),
    );

    result.when(
      success: (_) {
        emit(state.copyWith(submitState: const BaseState.success(null)));
        doNavigationAction(const ForgetPasswordSuccessNavigation());
      },
      error: (exception) {
        emit(state.copyWith(submitState: BaseState.error(exception)));
        if (exception != null) {
          doNavigationAction(
            ForgetPasswordShowErrorNavigation(exception.toString()),
          );
        }
      },
    );
  }
}
