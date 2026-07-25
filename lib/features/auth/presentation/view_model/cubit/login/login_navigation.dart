part of 'login_cubit.dart';

sealed class LoginNavigation {
  const LoginNavigation();
}

class LoginSuccessNavigation extends LoginNavigation {
  const LoginSuccessNavigation();
}

/// The social account was already registered and is now signed in.
class LoginSocialSignedInNavigation extends LoginNavigation {
  const LoginSocialSignedInNavigation();
}

/// The social account exists on Firebase but its profile was never completed.
class LoginSocialProfileRequiredNavigation extends LoginNavigation {
  final Map<String, dynamic> socialData;

  const LoginSocialProfileRequiredNavigation(this.socialData);
}

class LoginShowErrorNavigation extends LoginNavigation {
  final String message;

  const LoginShowErrorNavigation(this.message);
}
