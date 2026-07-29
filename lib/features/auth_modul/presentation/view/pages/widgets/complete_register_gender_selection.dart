import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:fitness/core/enums/gender.dart';

class CompleteRegisterGenderSelection extends StatelessWidget {
  final Gender selectedGender;
  final ValueChanged<Gender> onChanged;

  const CompleteRegisterGenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption(Gender.male, Icons.male),
        const SizedBox(height: 30),
        _buildGenderOption(Gender.female, Icons.female),
      ],
    );
  }

  Widget _buildGenderOption(Gender gender, IconData icon) {
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
              color: isSelected ? AppColors.primaryOrange : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primaryOrange : Colors.white54,
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
            gender.localizedName,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
