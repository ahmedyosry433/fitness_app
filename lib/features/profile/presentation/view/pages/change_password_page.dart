import 'dart:ui';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/core/widgets/custom_back_button.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/widgets/glass_container.dart';
import 'package:fitness/features/profile/presentation/view/widgets/change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.changePasswordState != current.changePasswordState,
        listener: (context, state) {
          if (state.changePasswordState.state == StateType.success) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(LocaleKeys.custom_widget_done.tr()),
              autoCloseDuration: const Duration(seconds: 3),
            );
            context.pop();
          } else if (state.changePasswordState.state == StateType.error) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(state.changePasswordState.exception.toString()),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.black0C,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(AppImages.signupBack),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const CustomBackButton(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Image.asset(
                          AppImages.imagesIcLauncher,
                          height: 60,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.fitness_center,
                            size: 60,
                            color: AppColors.whiteFF,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  "Make Sure Its 8 Characters Or More",
                                  style: 14.regular.copyWith(
                                    color: AppColors.whiteFF,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  "Create New Password",
                                  style: 20.bold.copyWith(
                                    color: AppColors.whiteFF,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              GlassContainer(
                                borderRadius: BorderRadius.circular(40),
                                border: const Border.fromBorderSide(
                                  BorderSide.none,
                                ),
                                padding: const EdgeInsets.only(
                                  top: 32,
                                  left: 24,
                                  right: 24,
                                  bottom: 24,
                                ),
                                child: const ChangePasswordForm(),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
}
