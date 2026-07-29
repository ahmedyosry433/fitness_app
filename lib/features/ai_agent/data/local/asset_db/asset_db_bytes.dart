import 'package:flutter/services.dart';

/// Reads a bundled sqlite database from the asset bundle.
Future<Uint8List> loadAssetDatabaseBytes(String assetKey) async {
  final data = await rootBundle.load(assetKey);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
