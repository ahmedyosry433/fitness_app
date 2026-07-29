import 'package:fitness/features/ai_agent/presentation/view/formatting/chat_answer_section.dart';

/// Turns a raw model answer into short sections, one bubble each.
///
/// The model replies in light markdown, so headings, bullet runs and blank-line
/// separated paragraphs are used as the split points. A long wall of text
/// becomes a few readable bubbles instead of one.
abstract final class ChatAnswerSplitter {
  static final RegExp _heading = RegExp(r'^#{1,6}\s*(.+)$');
  static final RegExp _divider = RegExp(r'^\s*([-*_])\1{2,}\s*$');
  static final RegExp _bullet = RegExp(r'^\s*(?:[-*•]|\d+[.)])\s+(.+)$');
  static final RegExp _boldOnlyLine = RegExp(r'^\s*\*\*(.+?)\*\*\s*:?\s*$');

  /// Keeps a bubble from growing back into a wall of text.
  static const int _maxParagraphsPerSection = 2;

  static List<ChatAnswerSection> split(String raw) {
    final lines = raw.replaceAll('\r\n', '\n').split('\n');

    final sections = <ChatAnswerSection>[];
    final blocks = <ChatAnswerBlock>[];
    final paragraph = <String>[];
    final bullets = <String>[];
    String? title;
    var paragraphCount = 0;

    void flushParagraph() {
      if (paragraph.isEmpty) return;
      blocks.add(ChatAnswerBlock.paragraph(paragraph.join('\n').trim()));
      paragraph.clear();
      paragraphCount++;
    }

    void flushBullets() {
      if (bullets.isEmpty) return;
      blocks.add(ChatAnswerBlock.bullets(List<String>.unmodifiable(bullets)));
      bullets.clear();
    }

    void flushSection() {
      flushParagraph();
      flushBullets();
      final section = ChatAnswerSection(
        title: title,
        blocks: List<ChatAnswerBlock>.unmodifiable(blocks),
      );
      if (!section.isEmpty) sections.add(section);
      blocks.clear();
      title = null;
      paragraphCount = 0;
    }

    for (final rawLine in lines) {
      final line = rawLine.trimRight();
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        flushParagraph();
        flushBullets();
        if (paragraphCount >= _maxParagraphsPerSection) flushSection();
        continue;
      }

      if (_divider.hasMatch(trimmed)) {
        flushSection();
        continue;
      }

      final headingMatch = _heading.firstMatch(trimmed);
      final boldTitleMatch = _boldOnlyLine.firstMatch(trimmed);
      final headingText =
          headingMatch?.group(1)?.trim() ?? boldTitleMatch?.group(1)?.trim();

      if (headingText != null && headingText.isNotEmpty) {
        flushSection();
        title = _stripInlineMarkers(headingText);
        continue;
      }

      final bulletMatch = _bullet.firstMatch(line);
      if (bulletMatch != null) {
        flushParagraph();
        bullets.add(bulletMatch.group(1)!.trim());
        continue;
      }

      flushBullets();
      paragraph.add(trimmed);
    }

    flushSection();

    if (sections.isEmpty) {
      final fallback = raw.trim();
      if (fallback.isEmpty) return const [];
      return [
        ChatAnswerSection(blocks: [ChatAnswerBlock.paragraph(fallback)]),
      ];
    }

    return sections;
  }

  static String _stripInlineMarkers(String value) =>
      value.replaceAll(RegExp(r'\*{1,3}|`|_{2,}'), '').trim();
}
