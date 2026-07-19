import 'package:dio/dio.dart';
import 'package:fitness/config/meta/meta_horizon_config.dart';
import 'package:fitness/features/auth_modul/data/models/social_account_model.dart';
import 'package:injectable/injectable.dart';

/// Service responsible for Meta Horizon (Oculus / Horizon OS) user authentication inside auth_modul.
///
/// Ref: https://developers.meta.com/horizon/documentation/android-apps/authentication/
@lazySingleton
class MetaHorizonAuthService {
  final Dio _dio;

  MetaHorizonAuthService(this._dio);

  /// Authenticates with Meta Horizon using an OAuth access token or Platform User token.
  ///
  /// Fetches profile details from `https://graph.oculus.com/user/me`.
  Future<SocialAccountModel> fetchHorizonProfile(String accessToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${MetaHorizonConfig.apiBaseUrl}/user/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Failed to retrieve Meta Horizon profile: empty response.');
      }

      final id = data['id']?.toString() ?? '';
      final alias = data['alias']?.toString() ?? data['display_name']?.toString() ?? 'Meta Horizon User';
      final photoUrl = data['profile_url']?.toString() ?? '';
      final email = data['email']?.toString() ?? '';

      return SocialAccountModel(
        uid: 'meta_horizon_$id',
        name: alias,
        email: email,
        photoUrl: photoUrl,
      );
    } on DioException catch (e) {
      throw Exception('Meta Horizon profile request failed: ${e.message}');
    }
  }

  /// Generates the Meta Horizon OAuth authorization URL for web/mobile OAuth flow.
  String buildOAuthUrl({required String redirectUri, required String state}) {
    final params = Uri(
      queryParameters: {
        'client_id': MetaHorizonConfig.appId,
        'response_type': 'token',
        'redirect_uri': redirectUri,
        'state': state,
        'scope': 'user_info',
      },
    ).query;

    return '${MetaHorizonConfig.oauthAuthorizeUrl}?$params';
  }
}
