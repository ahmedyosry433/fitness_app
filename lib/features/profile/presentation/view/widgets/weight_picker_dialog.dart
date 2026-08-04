import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/blurred_background_wrapper.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_app_bar.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_number_picker.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_step_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WeightPickerDialog extends StatefulWidget {
  final int initialWeight;
  const WeightPickerDialog({super.key, required this.initialWeight});

  @override
  State<WeightPickerDialog> createState() => _WeightPickerDialogState();
}

class _WeightPickerDialogState extends State<WeightPickerDialog> {
  late int _currentWeight;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.initialWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackgroundWrapper(
        imagePath: AppImages.signupBack,
        child: SafeArea(
          child: Column(
            children: [
              CompleteRegisterAppBar(onBack: () => context.pop()),
              Expanded(
                child: CompleteRegisterStepContent(
                  title: LocaleKeys.complete_register_what_is_your_weight.tr(),
                  subtitle: LocaleKeys
                      .complete_register_this_helps_us_create_your_personalized_plan
                      .tr(),
                  buttonText: LocaleKeys.custom_widget_done.tr(),
                  onNext: () {
                    context.pop(_currentWeight);
                  },
                  child: CompleteRegisterNumberPicker(
                    minValue: 30,
                    maxValue: 200,
                    initialValue: _currentWeight,
                    label: LocaleKeys.complete_register_kg.tr(),
                    onChanged: (val) {
                      _currentWeight = val;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
