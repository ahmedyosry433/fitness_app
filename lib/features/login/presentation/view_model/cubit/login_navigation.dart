part of 'login_cubit.dart';

sealed class LoginNavigation {
  const LoginNavigation();
}

class LoginSuccessNavigation extends LoginNavigation {
  const LoginSuccessNavigation();
}

class LoginShowErrorNavigation extends LoginNavigation {
  final String message;

  const LoginShowErrorNavigation(this.message);
}
