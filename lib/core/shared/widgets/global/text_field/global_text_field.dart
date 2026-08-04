import 'package:fitness/core/shared/widgets/global/text_field/global_text_field_theme.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlobalTextField extends StatelessWidget {
  const GlobalTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.isObscure = false,
    this.prefixIcon,
    this.prefixIconAsset,
    this.suffixIcon,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.width = GlobalTextFieldTheme.fieldWidth,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isObscure;
  final IconData? prefixIcon;
  final String? prefixIconAsset;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: isObscure,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmitted,
          style: GlobalTextFieldTheme.textStyle,
          cursorColor: AppColors.fitnessOrange,
          decoration: GlobalTextFieldTheme.decoration(
            hintText: hintText,
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (prefixIconAsset != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(
          start: GlobalTextFieldTheme.horizontalPadding,
          end: GlobalTextFieldTheme.fieldIconGap,
        ),
        child: SvgPicture.asset(
          prefixIconAsset!,
          width: GlobalTextFieldTheme.fieldIconSize,
          height: GlobalTextFieldTheme.fieldIconSize,
          colorFilter: ColorFilter.mode(
            GlobalTextFieldTheme.fieldHintColor,
            BlendMode.srcIn,
          ),
        ),
      );
    }
    if (prefixIcon != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(
          start: GlobalTextFieldTheme.horizontalPadding,
          end: GlobalTextFieldTheme.fieldIconGap,
        ),
        child: Icon(
          prefixIcon,
          size: GlobalTextFieldTheme.fieldIconSize,
          color: AppColors.white.withValues(alpha: 0.85),
        ),
      );
    }
    return null;
  }
}
