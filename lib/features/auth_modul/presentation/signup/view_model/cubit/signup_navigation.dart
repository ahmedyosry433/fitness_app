part of 'signup_cubit.dart';

sealed class SignUpNavigation {
  const SignUpNavigation();
}

class SignUpSuccessNavigation extends SignUpNavigation {
  final AuthCommonResponse? response;
  final Map<String, dynamic> userData;

  const SignUpSuccessNavigation([this.response, this.userData = const {}]);
}

class SignUpShowErrorNavigation extends SignUpNavigation {
  final String message;

  const SignUpShowErrorNavigation(this.message);
}
