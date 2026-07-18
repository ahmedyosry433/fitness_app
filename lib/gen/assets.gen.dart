// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Calendar.svg
  String get calendar => 'assets/icons/Calendar.svg';

  /// File path: assets/icons/clock.svg
  String get clock => 'assets/icons/clock.svg';

  /// File path: assets/icons/close_eye.svg
  String get closeEye => 'assets/icons/close_eye.svg';

  /// List of all assets
  List<String> get values => [calendar, clock, closeEye];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/back.jpg
  AssetGenImage get back => const AssetGenImage('assets/images/back.jpg');

  /// File path: assets/images/full_shot_man.png
  AssetGenImage get fullShotMan =>
      const AssetGenImage('assets/images/full_shot_man.png');

  /// File path: assets/images/human_gym.png
  AssetGenImage get humanGym =>
      const AssetGenImage('assets/images/human_gym.png');

  /// File path: assets/images/human_gym2.png
  AssetGenImage get humanGym2 =>
      const AssetGenImage('assets/images/human_gym2.png');

  /// File path: assets/images/human_gym3.png
  AssetGenImage get humanGym3 =>
      const AssetGenImage('assets/images/human_gym3.png');

  /// File path: assets/images/ic_launcher.png
  AssetGenImage get icLauncher =>
      const AssetGenImage('assets/images/ic_launcher.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    back,
    fullShotMan,
    humanGym,
    humanGym2,
    humanGym3,
    icLauncher,
  ];
}

class $AssetsLocalizationGen {
  const $AssetsLocalizationGen();

  /// File path: assets/localization/ar-Eg.json
  String get arEg => 'assets/localization/ar-Eg.json';

  /// File path: assets/localization/en-US.json
  String get enUS => 'assets/localization/en-US.json';

  /// List of all assets
  List<String> get values => [arEg, enUS];
}

abstract final class Assets {
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLocalizationGen localization = $AssetsLocalizationGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
