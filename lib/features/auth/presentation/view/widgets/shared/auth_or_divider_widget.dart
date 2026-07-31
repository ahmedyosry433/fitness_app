import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/auth_assets.dart';
import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthOrDividerWidget extends StatelessWidget {
  const AuthOrDividerWidget({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AuthUiConfig.orDividerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _OrDividerLine(),
          const SizedBox(width: AuthUiConfig.orLineGap),
          Text(label, style: AuthUiConfig.orLabelStyle),
          const SizedBox(width: AuthUiConfig.orLineGap),
          _OrDividerLine(),
        ],
      ),
    );
  }
}

class _OrDividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AuthUiConfig.orLineWidth,
      height: 1,
      color: AppColors.grayD3,
    );
  }
}
