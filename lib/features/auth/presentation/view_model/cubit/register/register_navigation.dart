part of 'register_cubit.dart';

sealed class RegisterNavigation {
  const RegisterNavigation();
}

class RegisterSuccessNavigation extends RegisterNavigation {
  const RegisterSuccessNavigation();
}

/// The social account was already registered and is now signed in.
class RegisterSocialSignedInNavigation extends RegisterNavigation {
  const RegisterSocialSignedInNavigation();
}

/// The social account exists on Firebase but its profile was never completed.
class RegisterSocialProfileRequiredNavigation extends RegisterNavigation {
  final Map<String, dynamic> socialData;

  const RegisterSocialProfileRequiredNavigation(this.socialData);
}

class RegisterShowErrorNavigation extends RegisterNavigation {
  final String message;

  const RegisterShowErrorNavigation(this.message);
}
