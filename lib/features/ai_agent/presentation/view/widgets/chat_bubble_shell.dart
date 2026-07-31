import 'dart:ui';

import 'package:flutter/material.dart';

/// Frosted container shared by every assistant bubble.
class ChatBubbleShell extends StatelessWidget {
  const ChatBubbleShell({super.key, required this.child});

  final Widget child;

  /// Square corner on the side the avatar sits on, so the bubble points at the
  /// speaker in both reading directions.
  static const BorderRadiusDirectional _radius = BorderRadiusDirectional.only(
    topEnd: Radius.circular(20),
    bottomStart: Radius.circular(20),
    bottomEnd: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    final radius = _radius.resolve(Directionality.of(context));

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF242424).withValues(alpha: 0.5),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
