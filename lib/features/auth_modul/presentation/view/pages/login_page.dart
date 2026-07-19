import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(LocaleKeys.login_title.tr())));
  }
}
