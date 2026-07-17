import 'package:fitness/core/values/auth_assets.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:fitness/features/auth/presentation/view_model/cubit/login/auth_social_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthSocialLoginRowWidget extends StatelessWidget {
  const AuthSocialLoginRowWidget({
    super.key,
    this.onFacebookTap,
    this.onGoogleTap,
    this.onAppleTap,
  });

  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AuthSocialButtonWidget(
          provider: AuthSocialProvider.facebook,
          onTap: onFacebookTap,
          child: SvgPicture.asset(
            AuthAssets.iconFacebook,
            width: AuthUiConfig.socialIconSize,
            height: AuthUiConfig.socialIconSize,
          ),
        ),
        const SizedBox(width: AuthUiConfig.socialIconGap),
        AuthSocialButtonWidget(
          provider: AuthSocialProvider.google,
          onTap: onGoogleTap,
          child: SvgPicture.asset(
            AuthAssets.iconGoogle,
            width: AuthUiConfig.socialIconSize,
            height: AuthUiConfig.socialIconSize,
          ),
        ),
        const SizedBox(width: AuthUiConfig.socialIconGap),
        AuthSocialButtonWidget(
          provider: AuthSocialProvider.apple,
          onTap: onAppleTap,
          child: SizedBox(
            width: AuthUiConfig.socialIconSize,
            height: AuthUiConfig.socialIconSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  AuthAssets.iconAppleBg,
                  width: AuthUiConfig.socialIconSize,
                  height: AuthUiConfig.socialIconSize,
                ),
                SvgPicture.asset(
                  AuthAssets.iconApple,
                  width: 13,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AuthSocialButtonWidget extends StatelessWidget {
  const AuthSocialButtonWidget({
    super.key,
    required this.provider,
    required this.child,
    required this.onTap,
  });

  final AuthSocialProvider provider;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuthUiConfig.socialIconSize),
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: SizedBox(
          width: AuthUiConfig.socialIconSize,
          height: AuthUiConfig.socialIconSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AuthUiConfig.socialIconSize),
            child: child,
          ),
        ),
      ),
    );
  }
}
