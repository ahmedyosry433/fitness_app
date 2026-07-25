import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

part 'login_events.dart';
part 'login_navigation.dart';
part 'login_states.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, LoginNavigation> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  @override
  Future<void> doAction(LoginEvent event) async => switch (event) {
    LoginSubmittedEvent() => _login(event),
    TogglePasswordVisibilityEvent() => _togglePassword(),
    SocialLoginEvent(:final provider) => _socialLogin(provider),
  };

  Future<void> _login(LoginSubmittedEvent event) async {
    if (state.loginState.state == StateType.loading) return;

    emit(state.copyWith(loginState: const BaseState.loading()));

    final result = await _authRepository.login(
      params: LoginParams(email: event.email, password: event.password),
    );

    result.when(
      success: (user) {
        emit(state.copyWith(loginState: BaseState.success(user)));
        doNavigationAction(const LoginSuccessNavigation());
      },
      error: (exception) {
        emit(state.copyWith(loginState: BaseState.error(exception)));
        if (exception != null) {
          doNavigationAction(LoginShowErrorNavigation(exception.toString()));
        }
      },
    );
  }

  void _togglePassword() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  Future<void> _socialLogin(AuthSocialProvider provider) async {
    if (state.loginState.state == StateType.loading) return;

    emit(state.copyWith(loginState: const BaseState.loading()));

    final result = await _authRepository.socialLogin(provider: provider);

    result.when(
      success: (socialResult) {
        if (socialResult == null) {
          final message = LocaleKeys.error_api_failure_unexpected_error.tr();
          emit(state.copyWith(loginState: BaseState.error(message)));
          doNavigationAction(LoginShowErrorNavigation(message));
          return;
        }
        // Not signed in yet: the profile still has to be completed, so the
        // state must not report a logged-in user.
        if (socialResult.isNewUser) {
          emit(state.copyWith(loginState: const BaseState.initial()));
          doNavigationAction(
            LoginSocialProfileRequiredNavigation(
              socialResult.completeRegisterArgs,
            ),
          );
          return;
        }
        emit(state.copyWith(loginState: BaseState.success(socialResult.user)));
        doNavigationAction(const LoginSocialSignedInNavigation());
      },
      error: (exception) {
        emit(state.copyWith(loginState: BaseState.error(exception)));
        if (exception != null) {
          final message = exception.toString().replaceFirst(
            RegExp(r'^Exception:\s*'),
            '',
          );
          doNavigationAction(LoginShowErrorNavigation(message));
        }
      },
    );
  }
}
