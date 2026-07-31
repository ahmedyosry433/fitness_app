import 'dart:io';

import 'package:fitness/features/ai_agent/data/local/asset_db/asset_db_bytes.dart';
import 'package:path_provider/path_provider.dart';

/// Copies a bundled sqlite asset into the app support directory and returns the
/// resulting file path.
///
/// The copy is refreshed whenever the bundled asset size no longer matches the
/// cached file, which covers app updates that ship a new database.
Future<String> seedAssetDatabasePath({
  required String assetKey,
  required String fileName,
}) async {
  final directory = await getApplicationSupportDirectory();
  final target = File('${directory.path}${Platform.pathSeparator}$fileName');

  final bytes = await loadAssetDatabaseBytes(assetKey);
  final isUpToDate =
      await target.exists() && await target.length() == bytes.length;

  if (!isUpToDate) {
    await target.parent.create(recursive: true);
    await target.writeAsBytes(bytes, flush: true);
  }

  return target.path;
}
