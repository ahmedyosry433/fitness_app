import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/signup_app_bar.dart';
import 'widgets/signup_step_content.dart';
import 'widgets/signup_gender_selection.dart';
import 'widgets/signup_number_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  String _selectedGender = 'Male';
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
    } else {
    }
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.1,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Image.asset(
                  'assets/images/singup_back.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                SignupAppBar(onBack: _previousStep),
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
                      SignupStepContent(
                        currentStep: _currentStep,
                        title: 'TELL US ABOUT YOURSELF!',
                        subtitle: 'We Need To Know Your Gender',
                        onNext: _nextStep,
                        child: SignupGenderSelection(
                          selectedGender: _selectedGender,
                          onChanged: (val) => setState(() => _selectedGender = val),
                        ),
                      ),
                      SignupStepContent(
                        currentStep: _currentStep,
                        title: 'HOW OLD ARE YOU ?',
                        subtitle: 'This Helps Us Create Your Personalized Plan',
                        onNext: _nextStep,
                        child: SignupNumberPicker(
                          minValue: 14,
                          maxValue: 100,
                          initialValue: _selectedAge,
                          label: 'Year',
                          onChanged: (val) => _selectedAge = val,
                        ),
                      ),
                      SignupStepContent(
                        currentStep: _currentStep,
                        title: 'WHAT IS YOUR WEIGHT ?',
                        subtitle: 'This Helps Us Create Your Personalized Plan',
                        onNext: _nextStep,
                        child: SignupNumberPicker(
                          minValue: 30,
                          maxValue: 200,
                          initialValue: _selectedWeight,
                          label: 'Kg',
                          onChanged: (val) => _selectedWeight = val,
                        ),
                      ),
                      SignupStepContent(
                        currentStep: _currentStep,
                        title: 'WHAT IS YOUR HEIGHT ?',
                        subtitle: 'This Helps Us Create Your Personalized Plan',
                        onNext: _nextStep,
                        child: SignupNumberPicker(
                          minValue: 100,
                          maxValue: 250,
                          initialValue: _selectedHeight,
                          label: 'CM',
                          onChanged: (val) => _selectedHeight = val,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
