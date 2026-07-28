/// Static configuration for Firebase-backed social authentication.
///
/// [googleServerClientId] is the **web** OAuth client id (client_type 3) taken
/// from `android/app/google-services.json`. It is required by google_sign_in
/// v7 as the `serverClientId` so Firebase receives a valid audience in the
/// Google id token. This value is public client configuration (not a secret).
abstract class FirebaseAuthConfig {
  static const String googleServerClientId =
      '653235729105-g5i76onlldfuc5tijdev15a86ut9orrp.apps.googleusercontent.com';

  /// Firestore collection that stores app user profiles keyed by Firebase uid.
  static const String usersCollection = 'users';
}
