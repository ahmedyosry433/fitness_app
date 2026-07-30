import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/config/base_state/base_state.dart';
import 'package:fitness/config/di/injectable_config.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/values/app_icons.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/ai_agent_background.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_image_source_sheet.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_input_bar.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_message_bubble.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/previous_conversations_drawer.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_intent.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_navigation.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_cubit.dart';
import 'package:fitness/features/ai_agent/presentation/view_model/cubit/ai_agent_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AiAgentChatPage extends StatefulWidget {
  const AiAgentChatPage({super.key, this.conversationId});

  final int? conversationId;

  @override
  State<AiAgentChatPage> createState() => _AiAgentChatPageState();
}

class _AiAgentChatPageState extends State<AiAgentChatPage> {
  final AiAgentCubit _cubit = getIt<AiAgentCubit>();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  StreamSubscription<AiAgentNavigation>? _navigationSubscription;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _navigationSubscription = _cubit.navigationStream.listen(_onNavigation);
    _cubit.doAction(OpenConversationIntent(widget.conversationId));
  }

  @override
  void dispose() {
    _navigationSubscription?.cancel();
    _cubit.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavigation(AiAgentNavigation action) {
    switch (action) {
      case ScrollToBottomNavigation():
        _scrollToBottom();
      case OpenChatNavigation():
        break;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    _messageController.clear();
    _cubit.doAction(SendMessageIntent(text));
  }

  Future<void> _pickImage() async {
    final source = await ChatImageSourceSheet.show(context);
    if (source == null) return;

    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1280,
      imageQuality: 85,
    );
    if (picked == null) return;

    _cubit.doAction(AttachImageIntent(picked.path));
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
          buildWhen: (previous, current) => previous.data != current.data,
          builder: (context, state) {
            final data = state.data ?? const AiAgentUIModel();

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
                            Text(
                              LocaleKeys.ai_agent_smart_coach.tr(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
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
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          itemCount: data.messages.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) =>
                              ChatMessageBubble(message: data.messages[index]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                        child: ChatInputBar(
                          controller: _messageController,
                          isSending: data.isStreaming,
                          attachedImagePath: data.pendingImagePath,
                          onSend: _sendMessage,
                          onPickImage: _pickImage,
                          onRemoveImage: () => _cubit.doAction(
                            const ClearImageAttachmentIntent(),
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
                      conversations: data.conversations,
                      onClose: _toggleDrawer,
                      onSelectConversation: (conversation) {
                        setState(() => _isDrawerOpen = false);
                        _cubit.doAction(
                          OpenConversationIntent(conversation.id),
                        );
                      },
                      onDeleteConversation: (conversation) => _cubit.doAction(
                        DeleteConversationIntent(conversation.id),
                      ),
                      onNewConversation: () {
                        setState(() => _isDrawerOpen = false);
                        _cubit.doAction(const StartNewConversationIntent());
                      },
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
