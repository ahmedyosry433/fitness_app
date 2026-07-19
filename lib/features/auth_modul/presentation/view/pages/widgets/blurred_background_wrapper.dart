import 'dart:ui';
import 'package:fitness/core/values/app_images.dart';
import 'package:flutter/material.dart';

class BlurredBackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const BlurredBackgroundWrapper({
    super.key,
    required this.child,
    this.imagePath = AppImages.signupBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.1,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[900]),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          child,
        ],
      ),
    );
  }
}
