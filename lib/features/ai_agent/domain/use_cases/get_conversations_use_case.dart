import 'package:fitness/features/ai_agent/domain/entities/conversation_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetConversationsUseCase {
  const GetConversationsUseCase(this.repository);

  final AiChatHistoryRepository repository;

  Future<List<ConversationEntity>> call() => repository.getConversations();
}
