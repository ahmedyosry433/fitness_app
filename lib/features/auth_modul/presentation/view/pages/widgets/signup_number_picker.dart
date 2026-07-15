import 'package:flutter/material.dart';
import 'horizontal_number_picker.dart';

class SignupNumberPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final String label;
  final ValueChanged<int> onChanged;

  const SignupNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFF4500),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            HorizontalNumberPicker(
              minValue: minValue,
              maxValue: maxValue,
              initialValue: initialValue,
              onChanged: onChanged,
            ),
            const Positioned(
              bottom: 0,
              child: Icon(
                Icons.arrow_drop_up,
                color: Color(0xFFFF4500),
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
