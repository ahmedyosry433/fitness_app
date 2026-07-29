part of 'register_cubit.dart';

sealed class RegisterNavigation {
  const RegisterNavigation();
}

class RegisterSuccessNavigation extends RegisterNavigation {
  const RegisterSuccessNavigation();
}

class RegisterSocialSignedInNavigation extends RegisterNavigation {
  const RegisterSocialSignedInNavigation();
}

class RegisterSocialProfileRequiredNavigation extends RegisterNavigation {
  final Map<String, dynamic> socialData;

  const RegisterSocialProfileRequiredNavigation(this.socialData);
}

class RegisterShowErrorNavigation extends RegisterNavigation {
  final String message;

  const RegisterShowErrorNavigation(this.message);
}
