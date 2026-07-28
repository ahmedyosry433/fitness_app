import 'package:fitness/features/ai_agent/data/datasource/ai_chat_local_datasource.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AiChatHistoryRepository)
class AiChatHistoryRepositoryImpl implements AiChatHistoryRepository {
  const AiChatHistoryRepositoryImpl(this._local);

  final AiChatLocalDatasource _local;

  @override
  Future<List<ConversationEntity>> getConversations() =>
      _local.getConversations();

  @override
  Stream<List<ConversationEntity>> watchConversations() =>
      _local.watchConversations();

  @override
  Future<List<ChatMessageEntity>> getMessages(int conversationId) =>
      _local.getMessages(conversationId);

  @override
  Future<int> startConversation(String title) =>
      _local.createConversation(title);

  @override
  Future<int> saveMessage({
    required int conversationId,
    required String text,
    required bool isUser,
    List<AiRefEntity> refs = const [],
    String? imagePath,
  }) {
    return _local.insertMessage(
      conversationId: conversationId,
      text: text,
      isUser: isUser,
      refs: refs,
      imagePath: imagePath,
    );
  }

  @override
  Future<void> updateMessage({
    required int messageId,
    required String text,
    List<AiRefEntity> refs = const [],
  }) {
    return _local.updateMessage(messageId: messageId, text: text, refs: refs);
  }

  @override
  Future<void> deleteConversation(int conversationId) =>
      _local.deleteConversation(conversationId);
}
