import 'package:fitness/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const HorizontalNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<HorizontalNumberPicker> createState() => _HorizontalNumberPickerState();
}

class _HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  late FixedExtentScrollController _controller;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _controller = FixedExtentScrollController(
      initialItem: widget.initialValue - widget.minValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: RotatedBox(
        quarterTurns: -1,
        child: ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: 80,
          physics: const FixedExtentScrollPhysics(),
          perspective: 0.0001,
          onSelectedItemChanged: (index) {
            final newValue = widget.minValue + index;
            setState(() {
              _selectedValue = newValue;
            });
            widget.onChanged(newValue);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.maxValue - widget.minValue + 1,
            builder: (context, index) {
              final value = widget.minValue + index;
              final isSelected = value == _selectedValue;
              return RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryOrange : Colors.white54,
                      fontSize: isSelected ? 36 : 24,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    child: Text(value.toString()),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
