import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerContainer extends StatelessWidget {
  const CustomShimmerContainer({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 12,
    this.baseColor,
    this.highlightColor,
  });

  final double height;
  final double width;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final softBase = baseColor ?? AppColors.black22.withValues(alpha: 0.55);
    final softHighlight =
        highlightColor ?? AppColors.gray5F.withValues(alpha: 0.35);

    return ClipRRect(
      borderRadius: radius,
      child: Shimmer.fromColors(
        baseColor: softBase,
        highlightColor: softHighlight,
        period: const Duration(milliseconds: 1400),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: softBase,
            borderRadius: radius,
          ),
        ),
      ),
    );
  }
}
