import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

part 'login_events.dart';
part 'login_navigation.dart';
part 'login_states.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, LoginEvent, LoginNavigation> {
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

    // TODO: integrate provider SDK / backend social auth endpoint.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(loginState: const BaseState.initial()));
    doNavigationAction(
      LoginShowErrorNavigation('${provider.name} login is not available yet'),
    );
  }
}
