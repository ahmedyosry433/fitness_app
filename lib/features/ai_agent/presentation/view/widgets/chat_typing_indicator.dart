import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_bubble_shell.dart';
import 'package:flutter/material.dart';

/// Shown while the assistant answer is still empty, so the wait has feedback
/// instead of an empty bubble.
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  static const int _dotCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubbleShell(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_dotCount, (index) {
              final progress = (_controller.value * _dotCount - index).clamp(
                0.0,
                1.0,
              );
              final opacity = 0.3 + 0.7 * (1 - (progress - 0.5).abs() * 2).clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 6),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrangeDark.withValues(
                      alpha: opacity,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
