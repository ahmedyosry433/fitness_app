import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';

class AuthSocialResult {
  final AuthUserEntity user;

  /// `true` when the social profile still has to go through complete register.
  final bool isNewUser;
  final String photoUrl;

  const AuthSocialResult({
    required this.user,
    required this.isNewUser,
    this.photoUrl = '',
  });

  /// Arguments the complete-register screen needs to finish the sign-up.
  Map<String, dynamic> get completeRegisterArgs {
    final nameParts = user.name.trim().split(RegExp(r'\s+'));
    return {
      'uid': user.id,
      'firstName': nameParts.isNotEmpty ? nameParts.first : user.name,
      'lastName': nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      'email': user.email,
      'photoUrl': photoUrl,
      'isSocial': true,
    };
  }
}
