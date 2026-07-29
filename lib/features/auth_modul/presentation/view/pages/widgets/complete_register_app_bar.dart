import 'package:fitness/core/values/app_images.dart';
import 'package:flutter/material.dart';
import 'package:fitness/core/widgets/custom_back_button.dart';
class CompleteRegisterAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const CompleteRegisterAppBar({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(onPressed: onBack),
          Image.asset(
            AppImages.imagesIcLauncher,
            height: 40,
            errorBuilder: (context, error, stackTrace) => const SizedBox(width: 40),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
