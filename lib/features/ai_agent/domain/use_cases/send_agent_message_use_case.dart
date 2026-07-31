import 'package:fitness/features/ai_agent/domain/entities/ai_agent_stream_event.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_user_context_entity.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ollama_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendAgentMessageUseCase {
  const SendAgentMessageUseCase(this.repository);

  final OllamaRepository repository;

  Stream<AiAgentStreamEvent> call(
    List<ChatMessageEntity> conversation, {
    AiUserContextEntity userContext = AiUserContextEntity.empty,
  }) => repository.sendMessage(conversation, userContext: userContext);
}
