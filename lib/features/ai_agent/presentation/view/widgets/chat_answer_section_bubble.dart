import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/ai_agent/presentation/view/formatting/chat_answer_section.dart';
import 'package:fitness/features/ai_agent/presentation/view/formatting/chat_inline_markdown.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_bubble_shell.dart';
import 'package:flutter/material.dart';

/// A single assistant bubble: optional title, then paragraphs and bullet lists.
class ChatAnswerSectionBubble extends StatelessWidget {
  const ChatAnswerSectionBubble({super.key, required this.section});

  final ChatAnswerSection section;

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryOrangeLight,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (section.title != null && section.title!.isNotEmpty) {
      children.add(Text(section.title!, style: _titleStyle));
    }

    for (final block in section.blocks) {
      if (children.isNotEmpty) children.add(const SizedBox(height: 8));

      switch (block.kind) {
        case ChatBlockKind.paragraph:
          children.add(
            Text.rich(
              TextSpan(
                children: ChatInlineMarkdown.parse(
                  block.text ?? '',
                  _bodyStyle,
                ),
              ),
            ),
          );
        case ChatBlockKind.bullets:
          children.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in block.items)
                  _BulletLine(text: item, style: _bodyStyle),
              ],
            ),
          );
      }
    }

    return ChatBubbleShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 6, end: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrangeDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(children: ChatInlineMarkdown.parse(text, style)),
            ),
          ),
        ],
      ),
    );
  }
}
