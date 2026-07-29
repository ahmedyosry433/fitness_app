import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_field_theme.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show XFile;

/// Renders a locally attached image. Bytes are read through `XFile` so the
/// widget stays platform agnostic.
class ChatImageThumbnail extends StatelessWidget {
  const ChatImageThumbnail({
    super.key,
    required this.imagePath,
    this.size,
    this.width,
    this.height,
    this.borderRadius = 16,
  });

  final String imagePath;
  final double? size;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width ?? size,
        height: height ?? size,
        child: FutureBuilder<Uint8List>(
          future: XFile(imagePath).readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _ThumbnailPlaceholder(
                  icon: Icons.broken_image_outlined,
                ),
              );
            }
            if (snapshot.hasError) {
              return const _ThumbnailPlaceholder(
                icon: Icons.broken_image_outlined,
              );
            }
            return const _ThumbnailPlaceholder(icon: Icons.image_outlined);
          },
        ),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          icon,
          size: ChatFieldTheme.iconSize,
          color: ChatFieldTheme.hintColor,
        ),
      ),
    );
  }
}
