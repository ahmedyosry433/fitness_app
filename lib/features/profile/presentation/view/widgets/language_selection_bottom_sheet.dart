import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.black2A,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.whiteFF.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.profile_select_language.tr(),
              style: 18.bold.copyWith(color: AppColors.whiteFF),
            ),
            const SizedBox(height: 16),
            _LanguageTile(
              title: LocaleKeys.profile_english.tr(),
              subtitle: 'English (US)',
              isSelected: currentLocale.languageCode == 'en',
              onTap: () {
                context.setLocale(englishLocale);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _LanguageTile(
              title: 'العربية',
              subtitle: 'Arabic (EG)',
              isSelected: currentLocale.languageCode == 'ar',
              onTap: () {
                context.setLocale(arabicLocale);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withValues(alpha: 0.15)
              : AppColors.black0C.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : AppColors.whiteFF.withValues(alpha: 0.05),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: 16.bold.copyWith(
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.whiteFF,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: 12.regular.copyWith(
                      color: AppColors.whiteFF.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryOrange,
                size: 24,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: AppColors.whiteFF.withValues(alpha: 0.3),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
