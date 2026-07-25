import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

part 'register_events.dart';
part 'register_navigation.dart';
part 'register_states.dart';

@injectable
class RegisterCubit
    extends BaseCubit<RegisterState, RegisterNavigation> {
  RegisterCubit(this._authRepository) : super(const RegisterState());

  final AuthRepository _authRepository;

  @override
  Future<void> doAction(RegisterEvent event) async => switch (event) {
        RegisterSubmittedEvent() => _register(event),
        SocialRegisterEvent(:final provider) => _socialRegister(provider),
        TogglePasswordVisibilityEvent() => _togglePassword(),
        ToggleConfirmPasswordVisibilityEvent() => _toggleConfirmPassword(),
      };

  Future<void> _register(RegisterSubmittedEvent event) async {
    if (state.registerState.state == StateType.loading) return;

    emit(state.copyWith(registerState: const BaseState.loading()));

    final result = await _authRepository.register(
      params: RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        rePassword: event.confirmPassword,
        phone: event.phone,
      ),
    );

    result.when(
      success: (user) {
        emit(state.copyWith(registerState: BaseState.success(user)));
        doNavigationAction(const RegisterSuccessNavigation());
      },
      error: (exception) {
        emit(state.copyWith(registerState: BaseState.error(exception)));
        if (exception != null) {
          doNavigationAction(RegisterShowErrorNavigation(exception.toString()));
        }
      },
    );
  }

  Future<void> _socialRegister(AuthSocialProvider provider) async {
    if (state.registerState.state == StateType.loading) return;

    emit(state.copyWith(registerState: const BaseState.loading()));

    final result = await _authRepository.socialLogin(provider: provider);

    result.when(
      success: (user) {
        emit(state.copyWith(registerState: BaseState.success(user)));
        doNavigationAction(const RegisterSuccessNavigation());
      },
      error: (exception) {
        emit(state.copyWith(registerState: BaseState.error(exception)));
        if (exception != null) {
          final message = exception
              .toString()
              .replaceFirst(RegExp(r'^Exception:\s*'), '');
          doNavigationAction(RegisterShowErrorNavigation(message));
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

