import 'dart:ui';

import 'package:fitness/core/values/app_images.dart';
import 'package:flutter/material.dart';

/// Shared blurred background used by the Smart Coach screens.
class AiAgentBackground extends StatelessWidget {
  const AiAgentBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppImages.chatBg, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.5),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.25, sigmaY: 6.25),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
