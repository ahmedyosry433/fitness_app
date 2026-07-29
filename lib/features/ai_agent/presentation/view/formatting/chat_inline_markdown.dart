import 'package:flutter/material.dart';

/// Minimal inline markdown for chat answers: `**bold**`, `*italic*`, `` `code` ``.
///
/// Only what the model actually emits is supported, so raw markers never leak
/// into the UI the way `###` and `**` did before.
abstract final class ChatInlineMarkdown {
  static final RegExp _pattern = RegExp(
    r'\*\*(?<bold>[^*]+)\*\*'
    r'|__(?<boldAlt>[^_]+)__'
    r'|\*(?<italic>[^*\n]+)\*'
    r'|`(?<code>[^`\n]+)`',
  );

  static List<InlineSpan> parse(String text, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    var index = 0;

    for (final match in _pattern.allMatches(text)) {
      if (match.start > index) {
        spans.add(
          TextSpan(text: text.substring(index, match.start), style: baseStyle),
        );
      }

      final bold = match.namedGroup('bold') ?? match.namedGroup('boldAlt');
      final italic = match.namedGroup('italic');
      final code = match.namedGroup('code');

      if (bold != null) {
        spans.add(
          TextSpan(
            text: bold,
            style: baseStyle.copyWith(fontWeight: FontWeight.w700),
          ),
        );
      } else if (italic != null) {
        spans.add(
          TextSpan(
            text: italic,
            style: baseStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (code != null) {
        spans.add(
          TextSpan(
            text: code,
            style: baseStyle.copyWith(
              fontFamily: 'monospace',
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        );
      }

      index = match.end;
    }

    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index), style: baseStyle));
    }

    return spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans;
  }
}
