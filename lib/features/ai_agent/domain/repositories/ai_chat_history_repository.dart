import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';

abstract interface class AiChatHistoryRepository {
  Future<List<ConversationEntity>> getConversations();

  Stream<List<ConversationEntity>> watchConversations();

  Future<List<ChatMessageEntity>> getMessages(int conversationId);

  Future<int> startConversation(String title);

  Future<int> saveMessage({
    required int conversationId,
    required String text,
    required bool isUser,
    List<AiRefEntity> refs = const [],
    String? imagePath,
  });

  Future<void> updateMessage({
    required int messageId,
    required String text,
    List<AiRefEntity> refs = const [],
  });

  Future<void> deleteConversation(int conversationId);
}
