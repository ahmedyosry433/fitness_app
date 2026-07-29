import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

Future<void> launchYouTubeVideo(String? url) async {
  if (url == null || url.isEmpty) return;
  final Uri uri = Uri.parse(url);

  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    log('Could not launch $url: $e');
  }
}
