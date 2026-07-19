import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/app.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/helper/bloc/bloc_observer.dart';
import 'package:fitness/core/languages/codegen_loader.g.dart';
import 'package:fitness/core/languages/lang.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [arabicLocale, englishLocale],
      fallbackLocale: englishLocale,
      startLocale: englishLocale,
      path: assetsLocalization,
      assetLoader: const CodegenLoader(),
      useFallbackTranslations: true,
      child: FitnessApp(),
    ),
  );
}
