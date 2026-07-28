import 'dart:ui';

import 'package:fitness/core/values/app_images.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/presentation/view/formatting/chat_answer_splitter.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_answer_section_bubble.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_image_thumbnail.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/chat_typing_indicator.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/exercise_ref_card.dart';
import 'package:fitness/features/ai_agent/presentation/view/widgets/meal_ref_card.dart';
import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessageEntity message;

  static const double _avatarRadius = 18;
  static const double _gutter = 12;
  static const double _oppositeInset = 40;

  @override
  Widget build(BuildContext context) {
    return message.isUser ? _UserMessage(message: message) : _BotMessage(
      message: message,
      avatarRadius: _avatarRadius,
      gutter: _gutter,
      oppositeInset: _oppositeInset,
    );
  }
}

/// Assistant turn: the answer is split into several short bubbles, and the
/// grounded cards are listed after them instead of being crammed inside.
class _BotMessage extends StatelessWidget {
  const _BotMessage({
    required this.message,
    required this.avatarRadius,
    required this.gutter,
    required this.oppositeInset,
  });

  final ChatMessageEntity message;
  final double avatarRadius;
  final double gutter;
  final double oppositeInset;

  @override
  Widget build(BuildContext context) {
    final sections = ChatAnswerSplitter.split(message.text);
    final isWaiting = sections.isEmpty && message.refs.isEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage: const AssetImage(AppImages.botAvatar),
          backgroundColor: Colors.transparent,
        ),
        SizedBox(width: gutter),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isWaiting) const ChatTypingIndicator(),
              for (var index = 0; index < sections.length; index++) ...[
                if (index > 0) const SizedBox(height: 8),
                ChatAnswerSectionBubble(section: sections[index]),
              ],
              if (message.refs.isNotEmpty) ...[
                const SizedBox(height: 8),
                for (final ref in message.refs) _RefCard(ref: ref),
              ],
            ],
          ),
        ),
        SizedBox(width: oppositeInset),
      ],
    );
  }
}

class _RefCard extends StatelessWidget {
  const _RefCard({required this.ref});

  final AiRefEntity ref;

  @override
  Widget build(BuildContext context) {
    return switch (ref.type) {
      AiRefType.exercise => ExerciseRefCard(id: ref.id, name: ref.name),
      AiRefType.meal => MealRefCard(id: ref.id, name: ref.name),
    };
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.message});

  final ChatMessageEntity message;

  static const BorderRadius _radius = BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 40),
        Flexible(
          child: ClipRRect(
            borderRadius: _radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6A00).withValues(alpha: 0.5),
                  borderRadius: _radius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.hasImage)
                      ChatImageThumbnail(
                        imagePath: message.imagePath!,
                        width: 180,
                        height: 180,
                      ),
                    if (message.hasImage && message.text.isNotEmpty)
                      const SizedBox(height: 8),
                    if (message.text.isNotEmpty)
                      Text(
                        message.text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(AppImages.userAvatar),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
