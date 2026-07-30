import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    this.width,
    this.height,
    required this.imagePath,
    this.fit,
    this.emptyColorFilter,
    this.color,
    this.radius,
    this.errorImage,
  });

  final double? width, height, radius;
  final String imagePath;
  final String? errorImage;
  final ColorFilter? emptyColorFilter;
  final BoxFit? fit;
  final Color? color;

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        color: color ?? AppColors.gray5F.withValues(alpha: 0.15),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          color: AppColors.gray5F,
          size: (width != null && width! < 60) ? 20 : 32,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _buildErrorPlaceholder();
    }

    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      imageUrl: imagePath,
      fadeInDuration: const Duration(milliseconds: 300),
      errorListener: (value) {
        log('Error loading image: $value|| $imagePath');
      },
      errorWidget: (context, url, error) => _buildErrorPlaceholder(),
      progressIndicatorBuilder: (context, url, progress) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 12),
          color: AppColors.black22.withValues(alpha: 0.25),
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: progress.progress,
              color: AppColors.primaryOrangeDark,
              strokeCap: StrokeCap.round,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }
}
