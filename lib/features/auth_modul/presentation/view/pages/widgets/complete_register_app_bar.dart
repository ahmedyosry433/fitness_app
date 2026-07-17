import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
          Image.asset(
            'assets/images/ic_launcher.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) => const SizedBox(width: 40),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
