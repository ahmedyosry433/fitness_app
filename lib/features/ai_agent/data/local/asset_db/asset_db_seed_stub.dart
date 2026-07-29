/// Fallback used on platforms without a file system.
Future<String> seedAssetDatabasePath({
  required String assetKey,
  required String fileName,
}) {
  throw UnsupportedError(
    'Seeding a database file is not supported on this platform.',
  );
}
