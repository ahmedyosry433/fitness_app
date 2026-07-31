import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_field_theme.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show XFile;

/// Renders a locally attached image. Bytes are cached in state so the widget
/// does NOT re-read the file on every rebuild, preventing the flickering and
/// "always loading" feeling.
class ChatImageThumbnail extends StatefulWidget {
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
  State<ChatImageThumbnail> createState() => _ChatImageThumbnailState();
}

class _ChatImageThumbnailState extends State<ChatImageThumbnail> {
  Uint8List? _bytes;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(ChatImageThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final bytes = await XFile(widget.imagePath).readAsBytes();
      if (mounted) {
        setState(() {
          _bytes = bytes;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width ?? widget.size,
        height: widget.height ?? widget.size,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError) {
      return const _ThumbnailPlaceholder(icon: Icons.broken_image_outlined);
    }
    if (_isLoading || _bytes == null) {
      return const _ThumbnailLoading();
    }
    return Image.memory(
      _bytes!,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) =>
          const _ThumbnailPlaceholder(icon: Icons.broken_image_outlined),
    );
  }
}

class _ThumbnailLoading extends StatelessWidget {
  const _ThumbnailLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.08),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryOrangeDark,
          ),
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
