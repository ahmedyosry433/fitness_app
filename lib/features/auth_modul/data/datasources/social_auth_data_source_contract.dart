import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:fitness/features/auth_modul/domain/entities/auth_social_provider.dart';

/// Performs the OAuth handshake with social providers (Google, Meta Horizon, Facebook) inside auth_modul.
abstract class SocialAuthDataSourceContract {
  /// Runs the provider sign-in flow and authenticates with Firebase / Meta.
  Future<SocialAccountModel> signIn(AuthSocialProvider provider);

  /// Links email and password to the signed-in user credential.
  Future<void> linkEmailPassword({
    required String email,
    required String password,
  });

  /// Signs out of all underlying social providers.
  Future<void> signOut();
}
