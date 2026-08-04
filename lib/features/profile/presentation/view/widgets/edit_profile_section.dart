import 'package:flutter/material.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';

class EditProfileSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final VoidCallback? onTap;

  const EditProfileSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: 14.bold.copyWith(color: AppColors.whiteFF),
            children: [
              TextSpan(
                text: ' $subtitle',
                style: 14.bold.copyWith(color: AppColors.primaryOrange),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.black32.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.whiteFF.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: 14.semiBold.copyWith(color: AppColors.whiteFF),
            ),
          ),
        ),
      ],
    );
  }
}
