import 'package:flutter/material.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData? icon;
  final Widget? leadingIcon;
  final String title;
  final String? trailingText;
  final Widget? trailingWidget;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;
  final Color? trailingColor;

  const ProfileMenuItem({
    super.key,
    this.icon,
    this.leadingIcon,
    required this.title,
    this.trailingText,
    this.trailingWidget,
    required this.onTap,
    this.titleColor,
    this.iconColor,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              leadingIcon ??
                  Icon(
                    icon,
                    color: iconColor ?? AppColors.primaryOrange,
                    size: 24,
                  ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: 16.regular.copyWith(
                    color: titleColor ?? AppColors.whiteFF,
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: 14.regular.copyWith(color: AppColors.primaryOrange),
                ),
                const SizedBox(width: 8),
              ],
              trailingWidget ??
                  Icon(
                    Icons.arrow_forward_ios,
                    color: trailingColor ?? AppColors.primaryOrange,
                    size: 16,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
