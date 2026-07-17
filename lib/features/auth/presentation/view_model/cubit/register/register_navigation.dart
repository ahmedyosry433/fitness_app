part of 'register_cubit.dart';

sealed class RegisterNavigation {
  const RegisterNavigation();
}

class RegisterSuccessNavigation extends RegisterNavigation {
  const RegisterSuccessNavigation();
}

class RegisterShowErrorNavigation extends RegisterNavigation {
  final String message;

  const RegisterShowErrorNavigation(this.message);
}
