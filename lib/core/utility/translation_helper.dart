import 'package:fitness/config/di/injectable_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class TranslationHelper {
  static final _translator = GoogleTranslator();

  /// Returns true if the current locale is Arabic.
  static bool _isArabic() {
    try {
      final prefs = getIt<SharedPreferences>();
      final locale = prefs.getString('locale') ?? 'en';
      return locale.contains('ar');
    } catch (_) {
      return false;
    }
  }

  static Future<String> translateText(String? text) async {
    if (text == null || text.trim().isEmpty) return text ?? '';

    if (!_isArabic()) return text;

    try {
      final translation = await _translator.translate(
        text,
        from: 'en',
        to: 'ar',
      );
      return translation.text;
    } catch (e) {
      // In case of error (e.g. no internet, rate limit), return the original text
      return text;
    }
  }

  /// Translates a list of strings dynamically.
  static Future<List<String>> translateList(List<String?> texts) async {
    final List<String> result = [];
    for (var text in texts) {
      result.add(await translateText(text));
    }
    return result;
  }
}
