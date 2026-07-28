import 'package:fitness/features/ai_agent/domain/entities/ai_agent_stream_event.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';

abstract interface class OllamaRepository {
  /// Streams the assistant answer for [conversation], where the last entry is
  /// the new user message.
  Stream<AiAgentStreamEvent> sendMessage(List<ChatMessageEntity> conversation);
}
