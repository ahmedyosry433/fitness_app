part of 'signup_cubit.dart';

sealed class SignUpNavigation {
  const SignUpNavigation();
}

class SignUpSuccessNavigation extends SignUpNavigation {
  final AuthCommonResponse? response;
  const SignUpSuccessNavigation([this.response]);
}

class SignUpShowErrorNavigation extends SignUpNavigation {
  final String message;

  const SignUpShowErrorNavigation(this.message);
}
