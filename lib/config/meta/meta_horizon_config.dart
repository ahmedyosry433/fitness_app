/// Static configuration for Meta Horizon / Meta Developer portal authentication.
///
/// Application Credentials configured from Meta Developer Dashboard (app: fitness).
/// Documentation: https://developers.meta.com/horizon/documentation/android-apps/authentication/
abstract class MetaHorizonConfig {
  /// Meta Application ID from Meta Developer Portal.
  static const String appId = '1716573716342339';

  /// Meta Application Secret key from Meta Developer Portal.
  static const String appSecret = '146018ea454c13c919313bed0a9756bd';

  /// Meta Client Token.
  static const String clientToken = '146018ea454c13c919313bed0a9756bd';

  /// Meta Horizon OAuth authorization endpoint.
  static const String oauthAuthorizeUrl = 'https://www.oculus.com/v2/dialog/oauth/';

  /// Meta Horizon Graph API base URL.
  static const String apiBaseUrl = 'https://graph.oculus.com';
}
