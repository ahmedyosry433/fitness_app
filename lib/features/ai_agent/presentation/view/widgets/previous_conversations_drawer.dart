import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/conversation_tile.dart';
import 'package:flutter/material.dart';

class PreviousConversationsDrawer extends StatelessWidget {
  const PreviousConversationsDrawer({
    super.key,
    required this.conversations,
    required this.onClose,
    required this.onSelectConversation,
    this.onDeleteConversation,
    this.onNewConversation,
  });

  final List<ConversationEntity> conversations;
  final VoidCallback onClose;
  final ValueChanged<ConversationEntity> onSelectConversation;
  final ValueChanged<ConversationEntity>? onDeleteConversation;
  final VoidCallback? onNewConversation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 275,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              color: const Color(0xFF242424).withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: onClose,
                      ),
                      Expanded(
                        child: Text(
                          LocaleKeys.ai_agent_previous_conversations.tr(),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (onNewConversation != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: onNewConversation,
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: AppColors.primaryOrangeDark,
                      ),
                      label: Text(
                        LocaleKeys.ai_agent_new_conversation.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryOrangeDark,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Expanded(
                    child: conversations.isEmpty
                        ? Center(
                            child: Text(
                              LocaleKeys.ai_agent_no_conversations.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: conversations.length,
                            itemBuilder: (context, index) {
                              final conversation = conversations[index];
                              return ConversationTile(
                                conversation: conversation,
                                onTap: () => onSelectConversation(conversation),
                                onDelete: onDeleteConversation == null
                                    ? null
                                    : () => onDeleteConversation!(conversation),
                              );
                            },
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
