import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_field_theme.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_image_thumbnail.dart';
import 'package:flutter/material.dart';

/// Thumbnail of the image staged for the next message, with a remove action.
class ChatAttachmentPreview extends StatelessWidget {
  const ChatAttachmentPreview({
    super.key,
    required this.imagePath,
    required this.onRemove,
  });

  final String imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ChatImageThumbnail(
              imagePath: imagePath,
              size: ChatFieldTheme.attachmentPreviewSize,
              borderRadius: 14,
            ),
            PositionedDirectional(
              top: -8,
              end: -8,
              child: Semantics(
                button: true,
                label: LocaleKeys.ai_agent_remove_image.tr(),
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(color: ChatFieldTheme.borderColor),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
