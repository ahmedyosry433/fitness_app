import 'dart:ui';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/widgets/custom_back_button.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness/features/profile/presentation/view/widgets/edit_profile_header.dart';
import 'package:fitness/features/profile/presentation/view/widgets/edit_profile_text_field.dart';
import 'package:fitness/features/profile/presentation/view/widgets/edit_profile_section.dart';
import 'package:fitness/features/profile/presentation/view/widgets/weight_picker_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:fitness/features/profile/domain/entities/user_entity.dart';
import 'package:fitness/core/utils/app_validators.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late ValueNotifier<int> _weightNotifier;
  late ValueNotifier<String> _goalNotifier;
  late ValueNotifier<String> _activityNotifier;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _weightNotifier = ValueNotifier<int>(90);
    _goalNotifier = ValueNotifier<String>(LocaleKeys.profile_gain_weight.tr());
    _activityNotifier = ValueNotifier<String>(LocaleKeys.profile_rookie.tr());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _weightNotifier.dispose();
    _goalNotifier.dispose();
    _activityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.getProfileState != current.getProfileState,
          listener: (context, state) {
            if (state.getProfileState.state == StateType.success) {
              final fullName = state.getProfileState.data?.name ?? '';
              final names = fullName.trim().split(' ');
              _firstNameController.text = names.isNotEmpty ? names.first : '';
              _lastNameController.text = names.length > 1
                  ? names.sublist(1).join(' ')
                  : '';
              _emailController.text = state.getProfileState.data?.email ?? '';
            } else if (state.getProfileState.state == StateType.error) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: Text(state.getProfileState.errorMessage ?? ''),
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.updateProfileState != current.updateProfileState,
          listener: (context, state) {
            if (state.updateProfileState.state == StateType.success) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: Text(LocaleKeys.custom_widget_done.tr()),
                autoCloseDuration: const Duration(seconds: 3),
              );
              context.pop();
            } else if (state.updateProfileState.state == StateType.error) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: Text(state.updateProfileState.errorMessage ?? ''),
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.uploadPhotoState != current.uploadPhotoState,
          listener: (context, state) {
            if (state.uploadPhotoState.state == StateType.error) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: Text(state.uploadPhotoState.errorMessage ?? ''),
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.black0C,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(AppImages.homeBack),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.black0C.withValues(alpha: 0.8),
                BlendMode.darken,
              ),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: SafeArea(
              child: Column(
                children: [
                  BlocSelector<ProfileCubit, ProfileState, bool>(
                    selector: (state) =>
                        state.updateProfileState.state == StateType.loading ||
                        state.uploadPhotoState.state == StateType.loading,
                    builder: (context, isLoading) {
                      return _buildAppBar(context, isLoading);
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocSelector<ProfileCubit, ProfileState, UserEntity?>(
                    selector: (state) => state.getProfileState.data,
                    builder: (context, user) {
                      return EditProfileHeader(
                        photoUrl: user?.photo,
                        name: user?.name,
                        onPickImage: () {
                          context.read<ProfileCubit>().doAction(
                            UploadPhotoEvent(),
                          );
                        },
                        selectedImage: null,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          EditProfileTextField(
                            controller: _firstNameController,
                            icon: Icons.person_outline,
                            hint: "First Name",
                            validator: AppValidators.validateRequired,
                          ),
                          const SizedBox(height: 16),
                          EditProfileTextField(
                            controller: _lastNameController,
                            icon: Icons.person_outline,
                            hint: "Last Name",
                            validator: AppValidators.validateRequired,
                          ),
                          const SizedBox(height: 16),
                          EditProfileTextField(
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            hint: "Email",
                            validator: AppValidators.validateEmail,
                          ),
                          const SizedBox(height: 30),
                          ValueListenableBuilder<int>(
                            valueListenable: _weightNotifier,
                            builder: (context, weight, child) {
                              return EditProfileSection(
                                title: LocaleKeys.profile_your_weight.tr(),
                                subtitle: LocaleKeys.profile_tap_to_edit.tr(),
                                value:
                                    '$weight ${LocaleKeys.complete_register_kg.tr()}',
                                onTap: () async {
                                  final result = await showDialog<int>(
                                    context: context,
                                    useSafeArea: false,
                                    builder: (context) {
                                      return WeightPickerDialog(
                                        initialWeight: weight,
                                      );
                                    },
                                  );
                                  if (result != null) {
                                    _weightNotifier.value = result;
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          ValueListenableBuilder<String>(
                            valueListenable: _goalNotifier,
                            builder: (context, goal, child) {
                              return EditProfileSection(
                                title: LocaleKeys.profile_your_goal.tr(),
                                subtitle: LocaleKeys.profile_tap_to_edit.tr(),
                                value: goal,
                                onTap: () async {
                                  final goals = [
                                    LocaleKeys.profile_gain_weight.tr(),
                                    "Lose Weight", // Ideally localized
                                    "Keep Fit", // Ideally localized
                                  ];
                                  final result = await _showSelectionDialog(
                                    context,
                                    LocaleKeys.profile_your_goal.tr(),
                                    goals,
                                    goal,
                                  );
                                  if (result != null) {
                                    _goalNotifier.value = result;
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          ValueListenableBuilder<String>(
                            valueListenable: _activityNotifier,
                            builder: (context, activity, child) {
                              return EditProfileSection(
                                title: LocaleKeys.profile_your_activity_level
                                    .tr(),
                                subtitle: LocaleKeys.profile_tap_to_edit.tr(),
                                value: activity,
                                onTap: () async {
                                  final activities = [
                                    LocaleKeys.profile_rookie.tr(),
                                    "Beginner", // Ideally localized
                                    "Intermediate", // Ideally localized
                                    "Advanced", // Ideally localized
                                  ];
                                  final result = await _showSelectionDialog(
                                    context,
                                    LocaleKeys.profile_your_activity_level.tr(),
                                    activities,
                                    activity,
                                  );
                                  if (result != null) {
                                    _activityNotifier.value = result;
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const CustomBackButton(),
          Center(
            child: Text(
              LocaleKeys.profile_edit_profile.tr(),
              style: 20.bold.copyWith(color: AppColors.whiteFF),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                      strokeWidth: 2,
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: AppColors.primaryOrange,
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final name =
                            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                                .trim();
                        final email = _emailController.text.trim();
                        final weight = _weightNotifier.value;
                        final goal = _goalNotifier.value;
                        final activityLevel = _activityNotifier.value;

                        context.read<ProfileCubit>().doAction(
                          UpdateProfileEvent(
                            name: name,
                            email: email.isNotEmpty ? email : null,
                            weight: weight,
                            goal: goal,
                            activityLevel: activityLevel,
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showSelectionDialog(
    BuildContext context,
    String title,
    List<String> items,
    String currentValue,
  ) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.black2A,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: 20.bold.copyWith(color: AppColors.whiteFF)),
                const SizedBox(height: 20),
                ...items.map(
                  (item) => ListTile(
                    title: Text(
                      item,
                      style: 16.medium.copyWith(
                        color: item == currentValue
                            ? AppColors.primaryOrange
                            : AppColors.whiteFF,
                      ),
                    ),
                    trailing: item == currentValue
                        ? const Icon(
                            Icons.check,
                            color: AppColors.primaryOrange,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
