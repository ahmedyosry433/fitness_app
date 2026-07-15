import 'package:flutter/material.dart';

class SignupStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SignupStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            strokeWidth: 3,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF4500)),
          ),
        ),
        Text(
          '${currentStep + 1}/$totalSteps',
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
