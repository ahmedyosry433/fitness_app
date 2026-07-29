import 'package:fitness/core/shared/widgets/global/text_field/global_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return GlobalTextField(
      controller: controller,
      hintText: hintText,
      validator: validator,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      prefixIcon: Icons.phone_outlined,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
