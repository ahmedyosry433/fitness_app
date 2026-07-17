import 'dart:ui';

import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:fitness/features/auth/presentation/view/widgets/shared/auth_top_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScaffoldWidget extends StatelessWidget {
  const AuthScaffoldWidget({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBack,
    this.backgroundImage = AuthUiConfig.backgroundImage,
    this.showTopLogo = false,
  });

  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;
  final String backgroundImage;
  final bool showTopLogo;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.authCharcoal,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AuthBackgroundImageWidget(imagePath: backgroundImage),
            if (showTopLogo) const AuthTopLogoOverlayWidget(),
            if (showBackButton)
              SafeArea(
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}

class AuthBackgroundImageWidget extends StatelessWidget {
  const AuthBackgroundImageWidget({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: AuthUiConfig.backgroundBlurSigma,
            sigmaY: AuthUiConfig.backgroundBlurSigma,
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        ColoredBox(color: AuthUiConfig.screenOverlayColor),
      ],
    );
  }
}

class AuthTopLogoOverlayWidget extends StatelessWidget {
  const AuthTopLogoOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AuthUiConfig.logoTopOffset,
      left: 0,
      right: 0,
      child: const AuthTopLogoWidget(),
    );
  }
}
