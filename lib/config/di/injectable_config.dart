import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable_config.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();
// dart run build_runner build --delete-conflicting-outputs
