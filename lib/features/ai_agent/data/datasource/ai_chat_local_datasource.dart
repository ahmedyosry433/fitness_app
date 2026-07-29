import 'dart:convert';

import 'package:fitness/features/ai_agent/data/local/ai_chat_database.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';
import 'package:injectable/injectable.dart';

/// Drift-backed local storage for conversations and messages.
@lazySingleton
class AiChatLocalDatasource {
  const AiChatLocalDatasource(this._database);

  final AiChatDatabase _database;

  Future<List<ConversationEntity>> getConversations() async {
    final rows = await _database.getConversations();
    return rows.map(_toConversation).toList();
  }

  Stream<List<ConversationEntity>> watchConversations() {
    return _database.watchConversations().map(
      (rows) => rows.map(_toConversation).toList(),
    );
  }

  Future<List<ChatMessageEntity>> getMessages(int conversationId) async {
    final rows = await _database.getMessages(conversationId);
    return rows.map(_toMessage).toList();
  }

  Future<int> createConversation(String title) =>
      _database.createConversation(title);

  Future<int> insertMessage({
    required int conversationId,
    required String text,
    required bool isUser,
    List<AiRefEntity> refs = const [],
    String? imagePath,
  }) {
    return _database.insertMessage(
      conversationId: conversationId,
      content: text,
      isUser: isUser,
      refsJson: encodeRefs(refs),
      imagePath: imagePath,
    );
  }

  Future<void> updateMessage({
    required int messageId,
    required String text,
    List<AiRefEntity> refs = const [],
  }) {
    return _database.updateMessage(
      messageId: messageId,
      content: text,
      refsJson: encodeRefs(refs),
    );
  }

  Future<void> deleteConversation(int conversationId) =>
      _database.deleteConversation(conversationId);

  static String? encodeRefs(List<AiRefEntity> refs) {
    if (refs.isEmpty) return null;
    return jsonEncode(refs.map((ref) => ref.toJson()).toList());
  }

  static List<AiRefEntity> decodeRefs(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((item) => AiRefEntity.tryFromJson(item.cast<String, dynamic>()))
          .whereType<AiRefEntity>()
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static ConversationEntity _toConversation(Conversation row) =>
      ConversationEntity(
        id: row.id,
        title: row.title,
        updatedAt: row.updatedAt,
      );

  static ChatMessageEntity _toMessage(ChatMessage row) => ChatMessageEntity(
    id: row.id,
    text: row.content,
    isUser: row.isUser,
    refs: decodeRefs(row.refsJson),
    imagePath: row.imagePath,
  );
}
