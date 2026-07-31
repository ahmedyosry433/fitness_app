import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/enums/gender.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/shared/widgets/custom_toast.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/data/models/register_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness/features/auth/data/social_auth_api_password.dart';
import 'package:fitness/features/auth_modul/data/services/user_firestore_service.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import 'widgets/blurred_background_wrapper.dart';
import 'widgets/complete_register_gender_selection.dart';
import 'widgets/complete_register_number_picker.dart';
import 'widgets/complete_register_radio_list.dart';
import 'widgets/complete_register_step_content.dart';

// ─── Goal options ────────────────────────────────────────────────────────────
const _goalOptions = [
  'Gain Weight',
  'Lose Weight',
  'Get Fitter',
  'Gain More Flexible',
  'Learn The Basic',
];

// ─── Activity Level options ───────────────────────────────────────────────────
const _activityOptions = [
  'Rookie',
  'Beginner',
  'Intermediate',
  'Advance',
  'True Beast',
];

class CompleteRegisterPage extends StatefulWidget {
  const CompleteRegisterPage({super.key});

  @override
  State<CompleteRegisterPage> createState() => _CompleteRegisterPageState();
}

class _CompleteRegisterPageState extends State<CompleteRegisterPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  Gender _selectedGender = Gender.male;
  int _selectedAge = 25;
  int _selectedWeight = 90;
  int _selectedHeight = 167;
  String _selectedGoal = _goalOptions.first;
  String _selectedActivity = _activityOptions.first;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitSignUp();
    }
  }

  Future<void> _submitSignUp() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final isSocial = extra?['isSocial'] == true;
    final uid = (extra?['uid'] as String?) ?? '';
    final photoUrl = extra?['photoUrl'] as String?;

    final genderStr = _selectedGender == Gender.female ? 'female' : 'male';

    final firstName = (extra?['firstName'] as String?) ?? 'Elevate';
    final lastName = (extra?['lastName'] as String?) ?? 'Tech';
    final email = (extra?['email'] as String?) ?? '';
    final rawPassword = (extra?['password'] as String?) ?? '';
    final phone = extra?['phone'] as String?;

    // Social users never type a password, so the API account is created with
    // the shared social password.
    final passToUse = rawPassword.isNotEmpty
        ? rawPassword
        : SocialAuthApiPassword.value;

    // For social sign-ups: Firestore is the source of truth.
    // Save the profile to Firestore immediately, then *try* registering on
    // the Elevate API as a best-effort step.
    if (isSocial) {
      final userIdToUse = uid.isNotEmpty
          ? uid
          : 'user_${DateTime.now().millisecondsSinceEpoch}';
      final fullName =
          '${firstName.isEmpty ? 'Elevate' : firstName} ${lastName.isEmpty ? 'Tech' : lastName}'
              .trim();

      // Save user profile in Cloud Firestore. Without this write the user is
      // not registered, so failing here must keep them on this screen.
      try {
        await getIt<UserFirestoreService>().saveUserProfile(
          uid: userIdToUse,
          name: fullName.isEmpty ? email : fullName,
          email: email,
          phone: phone,
          photoUrl: photoUrl,
          gender: genderStr,
          age: _selectedAge,
          weight: _selectedWeight,
          height: _selectedHeight,
          goal: _selectedGoal,
          activityLevel: _selectedActivity,
        );
      } catch (e) {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        CustomToast(
          context: context,
          header: LocaleKeys.error_api_failure_unexpected_error.tr(),
          type: ToastificationType.error,
        ).showToast();
        return;
      }

      // Best-effort: try to register on Elevate API so the user gets a JWT
      final repository = getIt<AuthRepository>();
      final params = RegisterParams(
        firstName: firstName.isEmpty ? 'Elevate' : firstName,
        lastName: lastName.isEmpty ? 'Tech' : lastName,
        email: email,
        password: passToUse,
        rePassword: passToUse,
        gender: genderStr,
        height: _selectedHeight,
        weight: _selectedWeight,
        age: _selectedAge,
        goal: _selectedGoal,
        activityLevel: _selectedActivity,
      );
      var apiResult = await repository.register(params: params);
      if (apiResult is Error) {
        // Account may already exist on Elevate API — try logging in
        final loginResult = await repository.login(
          params: LoginParams(email: email, password: passToUse),
        );
        if (loginResult is Success<AuthUserEntity>) {
          apiResult = loginResult;
        }
      }

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      // Save locally and navigate home regardless of Elevate API result
      final localDS = getIt<AuthLocalDataSourceContract>();
      if (apiResult is Success<AuthUserEntity> && apiResult.data != null) {
        await localDS.saveUser(apiResult.data!);
      } else {
        // Fallback: save a minimal local user so the app doesn't crash
        await localDS.saveUser(
          AuthUserEntity(
            id: userIdToUse,
            name: fullName,
            email: email,
            token: userIdToUse,
          ),
        );
      }

      if (!mounted) return;
      CustomToast(
        context: context,
        header: LocaleKeys.auth_register_success.tr(),
      ).showToast();
      context.go(Routes.home);
      return;
    }

    // --- Normal (non-social) registration ---
    final params = RegisterParams(
      firstName: firstName.isEmpty ? 'Elevate' : firstName,
      lastName: lastName.isEmpty ? 'Tech' : lastName,
      email: email,
      password: passToUse,
      rePassword: passToUse,
      gender: genderStr,
      height: _selectedHeight,
      weight: _selectedWeight,
      age: _selectedAge,
      goal: _selectedGoal,
      activityLevel: _selectedActivity,
    );

    final repository = getIt<AuthRepository>();
    final result = await repository.register(params: params);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      success: (user) {
        final userIdToUse = uid.isNotEmpty
            ? uid
            : (user?.id.isNotEmpty == true
                  ? user!.id
                  : 'user_${DateTime.now().millisecondsSinceEpoch}');
        final fullNameToSave = '${params.firstName} ${params.lastName}'.trim();

        // Mirror the profile in Cloud Firestore. The API already accepted the
        // registration, so a Firestore failure is logged, not blocking.
        getIt<UserFirestoreService>()
            .saveUserProfile(
              uid: userIdToUse,
              name: fullNameToSave.isEmpty ? email : fullNameToSave,
              email: email,
              phone: phone,
              photoUrl: photoUrl,
              gender: genderStr,
              age: _selectedAge,
              weight: _selectedWeight,
              height: _selectedHeight,
              goal: _selectedGoal,
              activityLevel: _selectedActivity,
            )
            .catchError((Object e, StackTrace stackTrace) {
              log(
                'Mirroring the registered profile to Firestore failed.',
                name: 'CompleteRegisterPage',
                error: e,
                stackTrace: stackTrace,
              );
            });

        CustomToast(
          context: context,
          header: LocaleKeys.auth_register_success.tr(),
        ).showToast();
        context.go(Routes.home);
      },
      error: (exception) {
        CustomToast(
          context: context,
          header:
              exception?.toString().replaceFirst(
                RegExp(r'^Exception:\s*'),
                '',
              ) ??
              'Registration failed',
          type: ToastificationType.error,
        ).showToast();
      },
    );
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
        context.go('/onBoard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurredBackgroundWrapper(
      imagePath: AppImages.signupBack,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
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
                      // ── Step 1: Gender ──────────────────────────────────
                      CompleteRegisterStepContent(
                        currentStep: _currentStep,
                        title: LocaleKeys
                            .complete_register_tell_us_about_yourself
                            .tr(),
                        subtitle: LocaleKeys
                            .complete_register_we_need_to_know_your_gender
                            .tr(),
                        onNext: _nextStep,
                        child: CompleteRegisterGenderSelection(
                          selectedGender: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                        ),
                      ),
                      // ── Step 2: Age ─────────────────────────────────────
                      CompleteRegisterStepContent(
                        currentStep: _currentStep,
                        title: LocaleKeys.complete_register_how_old_are_you
                            .tr(),
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
                      // ── Step 3: Weight ──────────────────────────────────
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
                      // ── Step 4: Height ──────────────────────────────────
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
                      // ── Step 5: Goal ────────────────────────────────────
                      CompleteRegisterStepContent(
                        currentStep: _currentStep,
                        title: 'WHAT IS YOUR GOAL ?',
                        subtitle:
                            'This Helps Us Create Your Personalized Plan',
                        onNext: _nextStep,
                        child: CompleteRegisterRadioList(
                          options: _goalOptions,
                          selectedOption: _selectedGoal,
                          onChanged: (val) =>
                              setState(() => _selectedGoal = val),
                        ),
                      ),
                      // ── Step 6: Activity Level ──────────────────────────
                      CompleteRegisterStepContent(
                        currentStep: _currentStep,
                        title: 'YOUR REGULAR PHYSICAL\nACTIVITY LEVEL ?',
                        subtitle: '',
                        onNext: _nextStep,
                        child: CompleteRegisterRadioList(
                          options: _activityOptions,
                          selectedOption: _selectedActivity,
                          onChanged: (val) =>
                              setState(() => _selectedActivity = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isSubmitting)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
