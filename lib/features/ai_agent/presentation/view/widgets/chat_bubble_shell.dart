import 'dart:ui';

import 'package:flutter/material.dart';

/// Frosted container shared by every assistant bubble.
class ChatBubbleShell extends StatelessWidget {
  const ChatBubbleShell({super.key, required this.child});

  final Widget child;

  static const BorderRadius _radius = BorderRadius.only(
    topRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF242424).withValues(alpha: 0.5),
            borderRadius: _radius,
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
