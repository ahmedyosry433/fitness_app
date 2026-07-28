import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Asks where the photo should come from before analysing it.
class ChatImageSourceSheet extends StatelessWidget {
  const ChatImageSourceSheet({super.key});

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF242424),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ChatImageSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.ai_agent_attach_image.tr(),
              style: ChatFieldTheme.textStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primaryOrangeDark,
              ),
              title: Text(
                LocaleKeys.ai_agent_image_source_gallery.tr(),
                style: ChatFieldTheme.textStyle,
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primaryOrangeDark,
              ),
              title: Text(
                LocaleKeys.ai_agent_image_source_camera.tr(),
                style: ChatFieldTheme.textStyle,
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}
