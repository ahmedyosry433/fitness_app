import 'dart:ui';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/routes/app_router.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_events.dart';
import 'package:fitness/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/widgets/custom_back_button.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:toastification/toastification.dart';
import 'package:fitness/features/profile/presentation/view/widgets/profile_menu_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness/features/profile/presentation/view/widgets/logout_confirmation_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.logoutState != current.logoutState,
      listener: (context, state) {
        if (state.logoutState.state == StateType.success) {
          context.go(Routes.login);
          return;
        } else if (state.logoutState.state == StateType.error) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            title: Text(state.logoutState.errorMessage ?? ''),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      },
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
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: SafeArea(
              child: Column(
                children: [
                  const _AppBar(),
                  const SizedBox(height: 20),
                  const _ProfileHeader(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.black2A.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Column(
                              children: [
                                ProfileMenuItem(
                                  icon: Icons.person_outline,
                                  title: LocaleKeys.profile_edit_profile.tr(),
                                  onTap: () {
                                    context.push(
                                      Routes.editProfile,
                                      extra: context.read<ProfileCubit>(),
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.whiteFF.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                ProfileMenuItem(
                                  icon: Icons.sync,
                                  title: LocaleKeys.profile_change_password
                                      .tr(),
                                  onTap: () {
                                    context.push(
                                      Routes.changePassword,
                                      extra: context.read<ProfileCubit>(),
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.whiteFF.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                ProfileMenuItem(
                                  icon: Icons.language,
                                  title: LocaleKeys.profile_select_language
                                      .tr(),
                                  trailingText:
                                      '(${context.locale.languageCode == 'en' ? LocaleKeys.profile_english.tr() : 'العربية'})',
                                  trailingWidget: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value:
                                          context.locale.languageCode == 'en',
                                      onChanged: (val) {
                                        if (val) {
                                          context.setLocale(
                                            const Locale('en', 'US'),
                                          );
                                        } else {
                                          context.setLocale(
                                            const Locale('ar', 'EG'),
                                          );
                                        }
                                      },
                                      activeTrackColor: AppColors.primaryOrange,
                                      activeThumbColor: AppColors.whiteFF,
                                      inactiveThumbColor: AppColors.grayEA,
                                      inactiveTrackColor: AppColors.black35,
                                      trackOutlineColor:
                                          WidgetStateProperty.all(
                                            Colors.transparent,
                                          ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.whiteFF.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                ProfileMenuItem(
                                  leadingIcon: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.settings_outlined,
                                        color: AppColors.primaryOrange,
                                        size: 24,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2.0,
                                        ),
                                        child: const Icon(
                                          Icons.lock_outline,
                                          color: AppColors.primaryOrange,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: LocaleKeys.profile_security.tr(),
                                  onTap: () {
                                    context.push(
                                      Routes.webView,
                                      extra: WebViewPageArguments(
                                        title: LocaleKeys.profile_security.tr(),
                                        url:
                                            'https://elevate-flutter-team.github.io/fitness-app-webviews/security.html',
                                      ),
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.whiteFF.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                ProfileMenuItem(
                                  icon: Icons.privacy_tip_outlined,
                                  title: LocaleKeys.profile_privacy_policy.tr(),
                                  onTap: () {
                                    context.push(
                                      Routes.webView,
                                      extra: WebViewPageArguments(
                                        title: LocaleKeys.profile_privacy_policy
                                            .tr(),
                                        url:
                                            'https://elevate-flutter-team.github.io/fitness-app-webviews/privacy-policy.html',
                                      ),
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.whiteFF.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                ProfileMenuItem(
                                  icon: Icons.help_outline,
                                  title: LocaleKeys.profile_help.tr(),
                                  onTap: () {
                                    context.push(
                                      Routes.webView,
                                      extra: WebViewPageArguments(
                                        title: LocaleKeys.profile_help.tr(),
                                        url:
                                            'https://elevate-flutter-team.github.io/fitness-app-webviews/help.html',
                                      ),
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: AppColors.whiteFF.withValues(
                                    alpha: 0.1,
                                  ),
                                ),

                                ProfileMenuItem(
                                  icon: Icons.logout,
                                  title: LocaleKeys.profile_logout.tr(),
                                  titleColor: AppColors.primaryOrange,
                                  iconColor: AppColors.primaryOrange,
                                  trailingColor: AppColors.primaryOrange,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return LogoutConfirmationDialog(
                                          onConfirm: () {
                                            context
                                                .read<ProfileCubit>()
                                                .doAction(LogoutEvent());
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const CustomBackButton(),
          Center(
            child: Text(
              LocaleKeys.profile_profile.tr(),
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.whiteFF) ??
                  20.bold.copyWith(color: AppColors.whiteFF),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.getProfileState != current.getProfileState,
      builder: (context, state) {
        final photo = state.getProfileState.data?.photo;
        final name = state.getProfileState.data?.name ?? "User Name";
        return Column(
          children: [
            _ProfileAvatar(photo: photo),
            const SizedBox(height: 12),
            Text(name, style: 18.bold.copyWith(color: AppColors.whiteFF)),
          ],
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? photo;
  const _ProfileAvatar({this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photo != null && photo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photo!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/ic_launcher.png',
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset('assets/images/ic_launcher.png', fit: BoxFit.cover),
      ),
    );
  }
}
