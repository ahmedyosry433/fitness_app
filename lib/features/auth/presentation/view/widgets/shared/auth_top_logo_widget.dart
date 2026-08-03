import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:flutter/material.dart';

class AuthTopLogoWidget extends StatelessWidget {
  const AuthTopLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: AuthUiConfig.logoWidth,
        height: AuthUiConfig.logoHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.71),
                blurRadius: 2.4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              AppImages.authLogo,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.32),
            ),
          ),
        ),
      ),
    );
  }
}
