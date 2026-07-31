import 'package:equatable/equatable.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';

/// Single UI model carried by `BaseState<AiAgentUIModel>`.
class AiAgentUIModel extends Equatable {
  const AiAgentUIModel({
    this.messages = const [],
    this.conversations = const [],
    this.conversationId,
    this.isStreaming = false,
    this.pendingImagePath,
    this.userName = '',
    this.userPhoto,
  });

  final List<ChatMessageEntity> messages;
  final List<ConversationEntity> conversations;
  final int? conversationId;
  final bool isStreaming;

  /// Image picked but not sent yet, shown as a preview above the input field.
  final String? pendingImagePath;

  final String userName;
  final String? userPhoto;

  bool get hasPendingImage =>
      pendingImagePath != null && pendingImagePath!.isNotEmpty;

  AiAgentUIModel copyWith({
    List<ChatMessageEntity>? messages,
    List<ConversationEntity>? conversations,
    int? conversationId,
    bool clearConversationId = false,
    bool? isStreaming,
    String? pendingImagePath,
    bool clearPendingImage = false,
    String? userName,
    String? userPhoto,
  }) {
    return AiAgentUIModel(
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
      conversationId: clearConversationId
          ? null
          : (conversationId ?? this.conversationId),
      isStreaming: isStreaming ?? this.isStreaming,
      pendingImagePath: clearPendingImage
          ? null
          : (pendingImagePath ?? this.pendingImagePath),
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    conversations,
    conversationId,
    isStreaming,
    pendingImagePath,
    userName,
    userPhoto,
  ];
}
