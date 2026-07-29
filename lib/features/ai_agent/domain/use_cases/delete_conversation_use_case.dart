import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteConversationUseCase {
  const DeleteConversationUseCase(this.repository);

  final AiChatHistoryRepository repository;

  Future<void> call(int conversationId) =>
      repository.deleteConversation(conversationId);
}
