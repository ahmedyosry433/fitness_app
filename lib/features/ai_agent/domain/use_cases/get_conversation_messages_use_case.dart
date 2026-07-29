import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetConversationMessagesUseCase {
  const GetConversationMessagesUseCase(this.repository);

  final AiChatHistoryRepository repository;

  Future<List<ChatMessageEntity>> call(int conversationId) =>
      repository.getMessages(conversationId);
}
