import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class StartConversationUseCase {
  const StartConversationUseCase(this.repository);

  final AiChatHistoryRepository repository;

  Future<int> call(String title) => repository.startConversation(title);
}
