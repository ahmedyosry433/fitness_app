import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/app.dart';
import 'package:fitness/config/api/ollama_config.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/helper/bloc/bloc_observer.dart';
import 'package:fitness/core/languages/codegen_loader.g.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:fitness/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  try {
    await OllamaConfig.load();
  await configureDependencies();
  } catch (e) {
    debugPrint('Dependencies configuration error: $e');
  }
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await EasyLocalization.ensureInitialized();
  } catch (e) {
    debugPrint('EasyLocalization initialization warning: $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: [arabicLocale, englishLocale],
      fallbackLocale: englishLocale,
      startLocale: englishLocale,
      path: assetsLocalization,
      assetLoader: const CodegenLoader(),
      useFallbackTranslations: true,
      child: const FitnessApp(),
    ),
  );

  FlutterNativeSplash.remove();
}
