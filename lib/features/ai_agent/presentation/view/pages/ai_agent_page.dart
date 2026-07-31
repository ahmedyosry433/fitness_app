import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:fitness/core/values/app_icons.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/ai_agent_background.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/previous_conversations_drawer.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_intent.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_navigation.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_cubit.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AiAgentPage extends StatefulWidget {
  const AiAgentPage({super.key});

  @override
  State<AiAgentPage> createState() => _AiAgentPageState();
}

class _AiAgentPageState extends State<AiAgentPage> {
  final AiAgentCubit _cubit = getIt<AiAgentCubit>();

  StreamSubscription<AiAgentNavigation>? _navigationSubscription;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _navigationSubscription = _cubit.navigationStream.listen(_onNavigation);
    _cubit.doAction(const LoadConversationsIntent());
  }

  @override
  void dispose() {
    _navigationSubscription?.cancel();
    _cubit.close();
    super.dispose();
  }

  void _onNavigation(AiAgentNavigation action) {
    if (action is OpenChatNavigation) {
      _openChat(action.conversationId);
    }
  }

  void _openChat(int? conversationId) {
    final query = conversationId == null
        ? ''
        : '?conversationId=$conversationId';
    context.push('${Routes.aiAgentChat}$query');
  }

  void _toggleDrawer() {
    setState(() => _isDrawerOpen = !_isDrawerOpen);
    if (_isDrawerOpen) _cubit.doAction(const LoadConversationsIntent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF242424),
        body: BlocBuilder<AiAgentCubit, BaseState<AiAgentUIModel>>(
          buildWhen: (previous, current) =>
              previous.data?.conversations != current.data?.conversations ||
              previous.data?.userName != current.data?.userName,
          builder: (context, state) {
            final data = state.data ?? const AiAgentUIModel();
            final conversations = data.conversations;
            final displayName = data.userName.isNotEmpty ? data.userName : '';

            return Stack(
              children: [
                const AiAgentBackground(),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (context.canPop()) context.pop();
                              },
                              child: SvgPicture.asset(
                                AppIcons.iconsBackOrange,
                                width: 32,
                                height: 32,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LocaleKeys.ai_agent_hi_user.tr(
                                    args: [displayName],
                                  ),
                                  style: 16.medium.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.ai_agent_i_am_your_smart_coach
                                      .tr(),
                                  style: 18.bold.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _toggleDrawer,
                              child: SvgPicture.asset(
                                AppIcons.iconsMenuOrange,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Center(
                            child: Image.asset(
                              AppImages.robotSkipping,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 95),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 17.3,
                              sigmaY: 17.3,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 32,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF242424,
                                ).withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    LocaleKeys.ai_agent_how_can_i_assist.tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () => _openChat(null),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.primaryOrangeDark,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        LocaleKeys.ai_agent_get_started.tr(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isDrawerOpen) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleDrawer,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PreviousConversationsDrawer(
                      conversations: conversations,
                      onClose: _toggleDrawer,
                      onSelectConversation: (conversation) {
                        setState(() => _isDrawerOpen = false);
                        _openChat(conversation.id);
                      },
                      onDeleteConversation: (conversation) => _cubit.doAction(
                        DeleteConversationIntent(conversation.id),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
