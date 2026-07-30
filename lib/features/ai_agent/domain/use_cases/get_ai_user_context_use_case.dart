import 'package:fitness/core/user_helper/user_helper.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_user_context_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

/// Builds the personalisation block sent with every assistant turn: cached
/// profile fields + a short recap of the last conversation with the user.
@injectable
class GetAiUserContextUseCase {
  const GetAiUserContextUseCase(this._userHelper, this._history);

  final UserHelper _userHelper;
  final AiChatHistoryRepository _history;

  /// Number of previous-chat turns kept, counted from the end.
  static const int maxPreviousTurns = 6;

  /// Each recalled turn is trimmed to keep the prompt small.
  static const int maxCharsPerTurn = 180;

  Future<AiUserContextEntity> call({
    int? currentConversationId,
    String? fallbackName,
  }) async {
    final profile = await _userHelper.getUserProfileContext();
    final previous = await _previousConversation(currentConversationId);

    final turns = previous == null
        ? const <ChatMessageEntity>[]
        : _compact(await _history.getMessages(previous.id));

    return AiUserContextEntity(
      name: profile['name'] ?? fallbackName,
      email: profile['email'],
      phone: profile['phone'],
      previousChatTitle: turns.isEmpty ? null : previous?.title,
      previousChatDate: turns.isEmpty ? null : previous?.updatedAt,
      previousChatTurns: turns,
    );
  }

  /// Most recently updated conversation that is not the open one.
  Future<ConversationEntity?> _previousConversation(int? currentId) async {
    try {
      final conversations = await _history.getConversations();
      for (final conversation in conversations) {
        if (conversation.id != currentId) return conversation;
      }
    } catch (_) {
      // History is a best-effort enrichment: never block the answer.
    }
    return null;
  }

  static List<ChatMessageEntity> _compact(List<ChatMessageEntity> messages) {
    final meaningful = messages
        .where((message) => message.text.trim().isNotEmpty)
        .toList();

    final tail = meaningful.length <= maxPreviousTurns
        ? meaningful
        : meaningful.sublist(meaningful.length - maxPreviousTurns);

    return tail
        .map((message) => message.copyWith(text: _truncate(message.text)))
        .toList();
  }

  static String _truncate(String text) {
    final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (flat.length <= maxCharsPerTurn) return flat;
    return '${flat.substring(0, maxCharsPerTurn)}…';
  }
}
