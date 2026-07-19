import 'package:equatable/equatable.dart';
import 'package:fitness/config/base_state/base_cubit.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/features/auth_modul/data/models/request/signup_request.dart';
import 'package:fitness/features/auth_modul/data/models/response/auth_common_response.dart';
import 'package:fitness/features/auth_modul/data/services/user_firestore_service.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';
import 'package:fitness/features/auth_modul/domain/use_cases/social_sign_in_use_case.dart';
import 'package:fitness/features/auth_modul/domain/use_cases/signup_use_case.dart';
import 'package:injectable/injectable.dart';

part 'signup_events.dart';
part 'signup_navigation.dart';
part 'signup_states.dart';

@injectable
class SignUpCubit extends BaseCubit<SignUpState, SignUpEvent, SignUpNavigation> {
  SignUpCubit(
    this._signUpUseCase,
    this._socialSignInUseCase,
    this._userFirestoreService,
  ) : super(const SignUpState());

  final SignUpUseCase _signUpUseCase;
  final SocialSignInUseCase _socialSignInUseCase;
  final UserFirestoreService _userFirestoreService;

  @override
  Future<void> doAction(SignUpEvent event) async => switch (event) {
        SignUpSubmittedEvent() => _signUp(event),
        SocialSignInSubmittedEvent() => _socialSignIn(event),
        TogglePasswordVisibilityEvent() => _togglePassword(),
        ToggleConfirmPasswordVisibilityEvent() => _toggleConfirmPassword(),
      };

  Future<void> _socialSignIn(SocialSignInSubmittedEvent event) async {
    if (state.signUpState.state == StateType.loading) return;

    emit(state.copyWith(signUpState: const BaseState.loading()));

    final result = await _socialSignInUseCase(event.provider);

    result.when(
      success: (account) async {
        if (account == null) return;
        await _userFirestoreService.saveUserProfile(
          uid: account.uid,
          name: account.name,
          email: account.email,
          photoUrl: account.photoUrl,
        );

        final response = AuthCommonResponse(
          status: 'success',
          message: 'Signed in as ${account.name}',
        );

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
