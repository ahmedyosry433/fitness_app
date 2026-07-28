import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_attachment_preview.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_field_theme.dart';
import 'package:flutter/material.dart';

/// The single chat field: text, one optional image attachment, and send.
///
/// Styled after the shared `GlobalTextField` pill look, but deliberately scoped
/// to this feature - it is a chat composer, not a reusable form field.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
    required this.onPickImage,
    required this.onRemoveImage,
    this.attachedImagePath,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final String? attachedImagePath;

  bool get _hasAttachment =>
      attachedImagePath != null && attachedImagePath!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hasAttachment)
          ChatAttachmentPreview(
            imagePath: attachedImagePath!,
            onRemove: onRemoveImage,
          ),
        TextFormField(
          controller: controller,
          style: ChatFieldTheme.textStyle,
          cursorColor: AppColors.primaryOrangeDark,
          minLines: 1,
          maxLines: 4,
          textInputAction: TextInputAction.send,
          keyboardType: TextInputType.multiline,
          enabled: !isSending,
          onFieldSubmitted: (_) => onSend(),
          decoration: ChatFieldTheme.decoration(
            hintText: LocaleKeys.ai_agent_message_hint.tr(),
            prefixIcon: _AttachButton(
              onPressed: isSending ? null : onPickImage,
              isActive: _hasAttachment,
            ),
            suffixIcon: _SendButton(
              onPressed: isSending ? null : onSend,
              isSending: isSending,
            ),
          ),
        ),
      ],
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({required this.onPressed, required this.isActive});

  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: ChatFieldTheme.horizontalPadding,
        end: 4,
      ),
      child: IconButton(
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        tooltip: LocaleKeys.ai_agent_attach_image.tr(),
        icon: Icon(
          isActive ? Icons.image_rounded : Icons.add_photo_alternate_outlined,
          size: ChatFieldTheme.iconSize,
          color: isActive
              ? AppColors.primaryOrangeDark
              : ChatFieldTheme.hintColor,
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onPressed, required this.isSending});

  final VoidCallback? onPressed;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 4,
        end: ChatFieldTheme.horizontalPadding,
      ),
      child: isSending
          ? const SizedBox(
              width: ChatFieldTheme.iconSize,
              height: ChatFieldTheme.iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryOrangeDark,
              ),
            )
          : IconButton(
              onPressed: onPressed,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: LocaleKeys.ai_agent_smart_coach.tr(),
              icon: const Icon(
                Icons.send_rounded,
                size: ChatFieldTheme.iconSize,
                color: AppColors.primaryOrangeDark,
              ),
            ),
    );
  }
}
