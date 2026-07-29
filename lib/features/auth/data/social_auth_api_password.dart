/// Password used for the Elevate API account that backs a social identity.
///
/// Social users (Google / Facebook) never type a password, yet the Elevate API
/// only issues a JWT for an email + password pair, so the app registers and
/// signs them in with this shared value.
///
/// NOTE: a single shared password means anyone knowing a social user's email can
/// obtain their API token. Replace it with a per-user secret (derived from the
/// Firebase uid, or a real social-login endpoint) as soon as the backend allows.
abstract class SocialAuthApiPassword {
  static const String value = 'Ahmed@123';
}
