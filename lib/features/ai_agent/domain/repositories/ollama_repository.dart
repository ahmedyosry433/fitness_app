import 'package:fitness/features/ai_agent/domain/entities/ai_agent_stream_event.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_user_context_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';

abstract interface class OllamaRepository {
  /// Streams the assistant answer for [conversation], where the last entry is
  /// the new user message. Optional [userContext] carries the cached profile
  /// fields and the recap of the previous chat, and is injected into the system
  /// prompt so the AI can personalise its responses.
  Stream<AiAgentStreamEvent> sendMessage(
    List<ChatMessageEntity> conversation, {
    AiUserContextEntity userContext,
  });
}
