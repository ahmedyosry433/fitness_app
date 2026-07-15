import 'package:flutter/material.dart';

class SignupGenderSelection extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const SignupGenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption('Male', Icons.male),
        const SizedBox(height: 30),
        _buildGenderOption('Female', Icons.female),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => onChanged(gender),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFFFF4500) : Colors.transparent,
              border: Border.all(
                color: isSelected ? const Color(0xFFFF4500) : Colors.white54,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            gender,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
