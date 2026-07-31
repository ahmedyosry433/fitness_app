import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PasswordCriteriaWidget extends StatefulWidget {
  final TextEditingController controller;

  const PasswordCriteriaWidget({super.key, required this.controller});

  @override
  State<PasswordCriteriaWidget> createState() => _PasswordCriteriaWidgetState();
}

class _PasswordCriteriaWidgetState extends State<PasswordCriteriaWidget> {
  String _password = '';

  @override
  void initState() {
    super.initState();
    _password = widget.controller.text;
    widget.controller.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {
      _password = widget.controller.text;
    });
  }

  bool _hasMinLength(String pwd) => pwd.length >= 8;
  bool _hasUppercase(String pwd) => RegExp(r'[A-Z]').hasMatch(pwd);
  bool _hasLowercase(String pwd) => RegExp(r'[a-z]').hasMatch(pwd);
  bool _hasNumber(String pwd) => RegExp(r'[0-9]').hasMatch(pwd);
  bool _hasSpecialChar(String pwd) => RegExp(r'[#?!@$%^&*-]').hasMatch(pwd);

  Widget _buildCriterion(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            color: isMet ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isMet
                    ? Colors.green
                    : AppColors.white.withValues(alpha: 0.7),
                fontSize: 12,
                fontFamily: 'RobotoEnglish',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriterion(
            LocaleKeys.forget_password_make_sure_8_characters_or_more.tr(),
            _hasMinLength(_password),
          ),
          _buildCriterion(
            LocaleKeys.validations_set_password_1_condition.tr(),
            _hasLowercase(_password),
          ),
          _buildCriterion(
            LocaleKeys.validations_set_password_2_condition.tr(),
            _hasUppercase(_password),
          ),
          _buildCriterion(
            LocaleKeys.validations_set_password_3_condition.tr(),
            _hasNumber(_password),
          ),
          _buildCriterion(
            LocaleKeys.validations_set_password_4_condition.tr(),
            _hasSpecialChar(_password),
          ),
        ],
      ),
    );
  }
}
