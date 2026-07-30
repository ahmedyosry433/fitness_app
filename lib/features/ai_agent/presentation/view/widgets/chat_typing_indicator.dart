import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Shown while the assistant answer is empty (AI agent is generating response).
/// Features a premium frosted glass container with animated gradient pulse,
/// AI sparkle icon, "Smart Coach is thinking..." text, and bouncing indicator dots.
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  static const int _dotCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.only(
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final animValue = _controller.value;
        final glowOpacity = 0.2 + 0.3 * math.sin(animValue * 2 * math.pi).abs();
        final iconScale = 0.9 + 0.2 * math.sin(animValue * 2 * math.pi).abs();

        return ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF242424).withValues(alpha: 0.7),
                borderRadius: radius,
                border: Border.all(
                  color: AppColors.primaryOrangeDark.withValues(
                    alpha: glowOpacity,
                  ),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrangeDark.withValues(
                      alpha: glowOpacity * 0.4,
                    ),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: iconScale,
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: AppColors.primaryOrangeLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.ai_agent_thinking.tr(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_dotCount, (index) {
                      final delay = index * 0.25;
                      final dotProgress = ((animValue - delay) % 1.0);
                      final bounce = math
                          .sin(dotProgress * math.pi)
                          .clamp(0.0, 1.0);
                      final opacity = 0.35 + 0.65 * bounce;
                      final yOffset = -3.5 * bounce;

                      return Transform.translate(
                        offset: Offset(0, yOffset),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrangeDark.withValues(
                              alpha: opacity,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (bounce > 0.5)
                                BoxShadow(
                                  color: AppColors.primaryOrangeLight
                                      .withValues(alpha: 0.6),
                                  blurRadius: 4,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
