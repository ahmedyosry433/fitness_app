import 'package:fitness/core/values/auth_ui_config.dart';
import 'package:flutter/material.dart';

class AuthGreetingHeaderWidget extends StatelessWidget {
  const AuthGreetingHeaderWidget({
    super.key,
    required this.greeting,
    required this.headline,
  });

  final String greeting;
  final String headline;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting, style: AuthUiConfig.greetingLightStyle),
          const SizedBox(height: 4),
          Text(headline, style: AuthUiConfig.greetingBoldStyle),
        ],
      ),
    );
  }
}
