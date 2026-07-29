/// Platform-specific seeding of the read-only knowledge databases that ship in
/// `assets/data/`.
///
/// On native platforms the asset is copied to a writable app directory and drift
/// opens that file. On the web there is no file system, so the bytes are handed
/// to drift through `DriftWebOptions.initializeDatabase` instead.
library;

export 'asset_db_seed_stub.dart'
    if (dart.library.io) 'asset_db_seed_io.dart'
    if (dart.library.js_interop) 'asset_db_seed_web.dart';
