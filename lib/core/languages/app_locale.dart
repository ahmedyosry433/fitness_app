import 'dart:developer';

import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads the active app language outside the widget tree.
///
/// `easy_localization` exposes the selected locale only through `BuildContext`,
/// but it persists it in [SharedPreferences] under `locale` (values such as
/// `en_US` / `ar_EG`). Data-layer code - the Smart Coach prompts and the
/// knowledge queries - needs the same value, so it is read back from that store
/// instead of keeping a second copy of the locale state in sync.
abstract final class AppLocale {
  /// Key used by `easy_localization` to persist the selected locale.
  static const String _preferenceKey = 'locale';

  /// Language code of the active locale. Falls back to the app start locale
  /// ([english]) when nothing has been persisted yet.
  static String get languageCode {
    try {
      final saved = getIt<SharedPreferences>().getString(_preferenceKey);
      if (saved == null || saved.trim().isEmpty) return english;
      return saved.split(RegExp('[_-]')).first.toLowerCase();
    } catch (error, stackTrace) {
      log(
        'Could not read the saved locale, falling back to $english',
        name: 'AppLocale',
        error: error,
        stackTrace: stackTrace,
      );
      return english;
    }
  }

  static bool get isArabic => languageCode == arabic;

  /// Language the AI must answer in, named in English so the model understands
  /// the instruction regardless of the prompt language.
  static String get answerLanguage => isArabic ? 'Arabic' : 'English';
}
