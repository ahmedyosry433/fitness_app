part of 'forget_password_cubit.dart';

sealed class ForgetPasswordNavigation {
  const ForgetPasswordNavigation();
}

class ForgetPasswordSuccessNavigation extends ForgetPasswordNavigation {
  const ForgetPasswordSuccessNavigation();
}

class ForgetPasswordShowErrorNavigation extends ForgetPasswordNavigation {
  final String message;

  const ForgetPasswordShowErrorNavigation(this.message);
}
