import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth_modul/data/datasources/social_auth_data_source_contract.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:injectable/injectable.dart';

part 'register_events.dart';
part 'register_navigation.dart';
part 'register_states.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState, RegisterNavigation> {
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

    final nameParts = event.name.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty ? nameParts.first : event.name;
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : 'Tech';

    final result = await _authRepository.register(
      params: RegisterParams(
        firstName: firstName,
        lastName: lastName,
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
      success: (socialResult) {
        if (socialResult == null) {
          final message = LocaleKeys.error_api_failure_unexpected_error.tr();
          emit(state.copyWith(registerState: BaseState.error(message)));
          doNavigationAction(RegisterShowErrorNavigation(message));
          return;
        }
        // Not registered yet: the profile still has to be completed, so the
        // state must not report a successful registration.
        if (socialResult.isNewUser) {
          emit(state.copyWith(registerState: const BaseState.initial()));
          doNavigationAction(
            RegisterSocialProfileRequiredNavigation(
              socialResult.completeRegisterArgs,
            ),
          );
          return;
        }
        emit(
          state.copyWith(registerState: BaseState.success(socialResult.user)),
        );
        doNavigationAction(const RegisterSocialSignedInNavigation());
      },
      error: (exception) {
        final message = exception != null
            ? exception.toString().replaceFirst(RegExp(r'^Exception:\s*'), '')
            : '';
        if (exception is SocialAuthCancelledException ||
            message.toLowerCase().contains('cancelled')) {
          emit(state.copyWith(registerState: const BaseState.initial()));
          return;
        }
        emit(state.copyWith(registerState: BaseState.error(exception)));
        if (exception != null) {
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
