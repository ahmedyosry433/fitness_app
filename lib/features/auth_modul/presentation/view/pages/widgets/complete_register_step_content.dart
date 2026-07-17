import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_step_indicator.dart';
import 'package:flutter/material.dart';

class CompleteRegisterStepContent extends StatelessWidget {
  final int currentStep;
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onNext;

  const CompleteRegisterStepContent({
    super.key,
    required this.currentStep,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 1),
        CompleteRegisterStepIndicator(currentStep: currentStep),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const Spacer(flex: 1),
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Expanded(child: Center(child: child)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      currentStep == 3 ? 'Done' : 'Next',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
