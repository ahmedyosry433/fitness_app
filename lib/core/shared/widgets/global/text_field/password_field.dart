import 'package:fitness/core/shared/widgets/global/text_field/global_text_field.dart';
import 'package:fitness/core/shared/widgets/global/text_field/global_text_field_theme.dart';
import 'package:fitness/core/values/field_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isObscure,
    required this.onToggleVisibility,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return GlobalTextField(
      controller: controller,
      hintText: hintText,
      validator: validator,
      isObscure: isObscure,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      prefixIconAsset: FieldAssets.iconLock,
      suffixIcon: IconButton(
        onPressed: onToggleVisibility,
        padding: const EdgeInsetsDirectional.only(
          end: GlobalTextFieldTheme.horizontalPadding,
        ),
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: GlobalTextFieldTheme.fieldIconSize,
        ),
        icon: SvgPicture.asset(
          FieldAssets.iconEye,
          width: GlobalTextFieldTheme.fieldIconSize,
          height: GlobalTextFieldTheme.fieldIconSize,
          colorFilter: ColorFilter.mode(
            GlobalTextFieldTheme.fieldHintColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
