import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:flutter/material.dart';

class AuthGlassCardWidget extends StatelessWidget {
  const AuthGlassCardWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AuthUiConfig.cardRadius),
      child: BackdropFilter(
        filter: AuthUiConfig.cardBlurFilter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AuthUiConfig.cardFillColor,
            borderRadius: BorderRadius.circular(AuthUiConfig.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AuthUiConfig.horizontalPadding,
              vertical: 24,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
