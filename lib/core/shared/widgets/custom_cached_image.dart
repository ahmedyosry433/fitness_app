import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  static bool _isRasterAsset(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif');
  }

  Widget _fallbackImage() {
    final fallback = errorImage ?? AppIcons.iconsNoProfile;
    if (_isRasterAsset(fallback)) {
      return Image.asset(
        fallback,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
      );
    }

    return SvgPicture.asset(
      fallback,
      fit: BoxFit.contain,
      width: width ?? 100,
      height: height ?? 100,
      colorFilter: emptyColorFilter ??
          ColorFilter.mode(AppColors.gray5F, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        padding: errorImage != null && errorImage!.endsWith(".png")
            ? EdgeInsets.zero
            : const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 12),
          color: color ?? AppColors.transparent,
        ),
        child: Center(
          child: (errorImage != null && !errorImage!.endsWith(".svg"))
              ? Image.asset(
                  errorImage!,
                  width: width,
                  height: height,
                  fit: fit ?? BoxFit.contain,
                )
              : SvgPicture.asset(
                  errorImage ?? AppIcons.iconsNoProfile,
                  fit: BoxFit.scaleDown,
                  width: 100,
                  height: 100,
                ),
        ),
      );
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
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 12),
          color: AppColors.primaryLight.withValues(alpha: 0.08),
        ),
        child: Center(
          child: (errorImage != null && !errorImage!.endsWith(".svg"))
              ? Image.asset(
                  errorImage!,
                  width: width,
                  height: height,
                  fit: fit ?? BoxFit.contain,
                )
              : SvgPicture.asset(
                  errorImage ?? AppIcons.iconsNoProfile,
                  fit: BoxFit.contain,
                  width: width,
                  height: height,
                  colorFilter:
                      emptyColorFilter ??
                      ColorFilter.mode(AppColors.gray5F, BlendMode.srcIn),
                ),
        ),
      ),
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
