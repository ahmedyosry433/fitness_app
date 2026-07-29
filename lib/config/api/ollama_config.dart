import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Ollama Cloud credentials, read from the bundled `.env` file.
///
/// The app talks to Ollama Cloud directly (no gateway server), so this key ships
/// inside the binary and can be extracted by reverse engineering. Treat it as a
/// shared, rotatable secret and keep an eye on the concurrency limits: every
/// device uses the same key, so bursts can return `429 Too Many Requests`.
abstract final class OllamaConfig {
  static const String envFileName = '.env';

  static const String _defaultBaseUrl = 'https://ollama.com';
  static const String _defaultModel = 'gpt-oss:20b';
  static const String _defaultVisionModel = 'gemma4:31b';
  static const String _defaultVisionFallbackModel = 'minimax-m3';

  /// Loads `.env`. Safe to call when the file is missing: the app then runs in
  /// local-only (degraded) mode instead of crashing at startup.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: envFileName);
    } catch (_) {
      // No `.env` bundled: getters fall back to defaults and the agent runs in
      // local-only mode.
    }
  }

  static String get apiKey => _read('OLLAMA_API_KEY', '');

  static String get baseUrl =>
      _read('OLLAMA_BASE_URL', _defaultBaseUrl).replaceAll(RegExp(r'/+$'), '');

  /// Text model. Must support tool calling.
  static String get model => _read('OLLAMA_MODEL', _defaultModel);

  /// Multimodal model used when the user attaches an image.
  static String get visionModel =>
      _read('OLLAMA_VISION_MODEL', _defaultVisionModel);

  /// Second multimodal model, tried when [visionModel] is unavailable.
  /// Ollama Cloud returns transient 5xx often enough that one model is not
  /// enough to keep image analysis working.
  static String get visionFallbackModel =>
      _read('OLLAMA_VISION_FALLBACK_MODEL', _defaultVisionFallbackModel);

  /// Vision models in priority order, without duplicates.
  static List<String> get visionModels {
    final models = <String>{visionModel, visionFallbackModel}
      ..removeWhere((model) => model.isEmpty);
    return models.toList();
  }

  static String get chatUrl => '$baseUrl/api/chat';

  static bool get isConfigured => apiKey.isNotEmpty;

  static String _read(String key, String fallback) {
    if (!dotenv.isInitialized) return fallback;
    final value = dotenv.maybeGet(key);
    if (value == null || value.trim().isEmpty) return fallback;
    return value.trim();
  }
}
