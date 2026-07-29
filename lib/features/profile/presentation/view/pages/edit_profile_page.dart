import 'dart:io';
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
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/blurred_background_wrapper.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_app_bar.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_number_picker.dart';
import 'package:fitness/features/auth_modul/presentation/view/pages/widgets/complete_register_step_content.dart';
import 'package:fitness/features/profile/presentation/view/widgets/edit_profile_header.dart';
import 'package:fitness/features/profile/presentation/view/widgets/edit_profile_text_field.dart';
import 'package:fitness/features/profile/presentation/view/widgets/edit_profile_section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toastification/toastification.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  File? _selectedImage;
  int _weight = 90;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
        );

        if (croppedFile != null) {
          setState(() {
            _selectedImage = File(croppedFile.path);
          });
        }
      }
    } finally {
      _isPickingImage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..doAction(LoadProfileEvent()),
      child: BlocConsumer<ProfileCubit, BaseState<ProfileUIModel>>(
        listener: (context, state) {
          if (state.state == StateType.success) {
            final fullName = state.data?.user?.name ?? '';
            final names = fullName.trim().split(' ');
            _firstNameController.text = names.isNotEmpty ? names.first : '';
            _lastNameController.text = names.length > 1
                ? names.sublist(1).join(' ')
                : '';
            _emailController.text = state.data?.user?.email ?? '';
            if (ModalRoute.of(context)?.isCurrent ?? false) {}
          } else if (state.state == StateType.error) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(state.exception.toString()),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.state == StateType.loading;

          return Scaffold(
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
                      _buildAppBar(context, isLoading),
                      const SizedBox(height: 20),
                      EditProfileHeader(
                        selectedImage: _selectedImage,
                        photoUrl: state.data?.user?.photo,
                        name: state.data?.user?.name,
                        onPickImage: _pickImage,
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            EditProfileTextField(
                              controller: _firstNameController,
                              icon: Icons.person_outline,
                              hint: LocaleKeys.auth_first_name.tr(),
                            ),
                            const SizedBox(height: 16),
                            EditProfileTextField(
                              controller: _lastNameController,
                              icon: Icons.person_outline,
                              hint: LocaleKeys.auth_last_name.tr(),
                            ),
                            const SizedBox(height: 16),
                            EditProfileTextField(
                              controller: _emailController,
                              icon: Icons.mail_outline,
                              hint: LocaleKeys.auth_email.tr(),
                            ),
                            const SizedBox(height: 30),
                            EditProfileSection(
                              title: LocaleKeys.profile_your_weight.tr(),
                              subtitle: LocaleKeys.profile_tap_to_edit.tr(),
                              value: '$_weight ${LocaleKeys.complete_register_kg.tr()}',
                              onTap: () async {
                                int currentSelectedWeight = _weight;
                                final result = await showDialog<int>(
                                  context: context,
                                  useSafeArea: false,
                                  builder: (context) {
                                    return Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: BlurredBackgroundWrapper(
                                        imagePath: AppImages.signupBack,
                                        child: SafeArea(
                                          child: Column(
                                            children: [
                                              CompleteRegisterAppBar(
                                                onBack: () => context.pop(),
                                              ),
                                              Expanded(
                                                child: CompleteRegisterStepContent(
                                                  title: LocaleKeys.complete_register_what_is_your_weight.tr(),
                                                  subtitle: LocaleKeys.complete_register_this_helps_us_create_your_personalized_plan.tr(),
                                                  buttonText: LocaleKeys.custom_widget_done.tr(),
                                                  onNext: () {
                                                    context.pop(currentSelectedWeight);
                                                  },
                                                  child: CompleteRegisterNumberPicker(
                                                    minValue: 30,
                                                    maxValue: 200,
                                                    initialValue: currentSelectedWeight,
                                                    label: LocaleKeys.complete_register_kg.tr(),
                                                    onChanged: (val) {
                                                      currentSelectedWeight = val;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (result != null) {
                                  setState(() {
                                    _weight = result;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            EditProfileSection(
                              title: LocaleKeys.profile_your_goal.tr(),
                              subtitle: LocaleKeys.profile_tap_to_edit.tr(),
                              value: LocaleKeys.profile_gain_weight.tr(),
                            ),
                            const SizedBox(height: 24),
                            EditProfileSection(
                              title: LocaleKeys.profile_your_activity_level.tr(),
                              subtitle: LocaleKeys.profile_tap_to_edit.tr(),
                              value: LocaleKeys.profile_rookie.tr(),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
                      final name =
                          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                              .trim();
                      if (name.isEmpty) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          title: Text(
                            LocaleKeys.validations_name_required.tr(),
                          ),
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                        return;
                      }
                      context.read<ProfileCubit>().doAction(
                        UpdateProfileEvent(
                          name: name,
                          profileImage: _selectedImage,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  }

