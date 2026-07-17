import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/complete_register_step_content.dart';
import 'widgets/complete_register_gender_selection.dart';
import 'widgets/complete_register_number_picker.dart';
import 'widgets/blurred_background_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/enums/gender.dart';

class CompleteRegisterPage extends StatefulWidget {
  const CompleteRegisterPage({super.key});

  @override
  State<CompleteRegisterPage> createState() => _CompleteRegisterPageState();
}

class _CompleteRegisterPageState extends State<CompleteRegisterPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  Gender _selectedGender = Gender.male;
  int _selectedAge = 25;
  int _selectedWeight = 90;
  int _selectedHeight = 167;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {}
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/onboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurredBackgroundWrapper(
      imagePath: 'assets/images/singup_back.png',
      child: SafeArea(
        child: Column(
          children: [
            CompleteRegisterAppBar(onBack: _previousStep),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  CompleteRegisterStepContent(
                    currentStep: _currentStep,
                    title: LocaleKeys.complete_register_tell_us_about_yourself
                        .tr(),
                    subtitle: LocaleKeys
                        .complete_register_we_need_to_know_your_gender
                        .tr(),
                    onNext: _nextStep,
                    child: CompleteRegisterGenderSelection(
                      selectedGender: _selectedGender,
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),
                  ),
                  CompleteRegisterStepContent(
                    currentStep: _currentStep,
                    title: LocaleKeys.complete_register_how_old_are_you.tr(),
                    subtitle: LocaleKeys
                        .complete_register_this_helps_us_create_your_personalized_plan
                        .tr(),
                    onNext: _nextStep,
                    child: CompleteRegisterNumberPicker(
                      minValue: 14,
                      maxValue: 100,
                      initialValue: _selectedAge,
                      label: LocaleKeys.complete_register_year.tr(),
                      onChanged: (val) => _selectedAge = val,
                    ),
                  ),
                  CompleteRegisterStepContent(
                    currentStep: _currentStep,
                    title: LocaleKeys.complete_register_what_is_your_weight
                        .tr(),
                    subtitle: LocaleKeys
                        .complete_register_this_helps_us_create_your_personalized_plan
                        .tr(),
                    onNext: _nextStep,
                    child: CompleteRegisterNumberPicker(
                      minValue: 30,
                      maxValue: 200,
                      initialValue: _selectedWeight,
                      label: LocaleKeys.complete_register_kg.tr(),
                      onChanged: (val) => _selectedWeight = val,
                    ),
                  ),
                  CompleteRegisterStepContent(
                    currentStep: _currentStep,
                    title: LocaleKeys.complete_register_what_is_your_height
                        .tr(),
                    subtitle: LocaleKeys
                        .complete_register_this_helps_us_create_your_personalized_plan
                        .tr(),
                    onNext: _nextStep,
                    child: CompleteRegisterNumberPicker(
                      minValue: 100,
                      maxValue: 250,
                      initialValue: _selectedHeight,
                      label: LocaleKeys.complete_register_cm.tr(),
                      onChanged: (val) => _selectedHeight = val,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
