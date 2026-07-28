/// On the web drift receives the database bytes via
/// `DriftWebOptions.initializeDatabase`, so no file needs to be seeded.
Future<String> seedAssetDatabasePath({
  required String assetKey,
  required String fileName,
}) {
  throw UnsupportedError(
    'seedAssetDatabasePath is not available on the web; '
    'DriftWebOptions.initializeDatabase is used instead.',
  );
}
