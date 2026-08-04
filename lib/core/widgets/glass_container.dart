import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitness/core/theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.border,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(25);
    return ClipRRect(
      borderRadius: effectiveBorderRadius as BorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          padding: padding ?? const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: color ?? AppColors.black32.withValues(alpha: 0.1),
            borderRadius: effectiveBorderRadius,
            border:
                border ??
                Border.all(
                  color: AppColors.whiteFF.withValues(alpha: 0.2),
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
