import 'dart:convert';

import 'package:image_picker/image_picker.dart' show XFile;
import 'package:injectable/injectable.dart';

/// Reads an attached image and encodes it the way Ollama expects
/// (`messages[].images` is a list of base64 strings).
///
/// `XFile` is used instead of `dart:io` so the data layer stays compilable on
/// every platform the app targets.
@lazySingleton
class ImageAttachmentEncoder {
  const ImageAttachmentEncoder();

  Future<String?> encodeToBase64(String? path) async {
    if (path == null || path.trim().isEmpty) return null;
    try {
      final bytes = await XFile(path).readAsBytes();
      if (bytes.isEmpty) return null;
      return base64Encode(bytes);
    } catch (_) {
      return null;
    }
  }
}
