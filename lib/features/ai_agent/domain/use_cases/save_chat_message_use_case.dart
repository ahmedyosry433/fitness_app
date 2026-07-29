import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveChatMessageUseCase {
  const SaveChatMessageUseCase(this.repository);

  final AiChatHistoryRepository repository;

  Future<int> call({
    required int conversationId,
    required String text,
    required bool isUser,
    List<AiRefEntity> refs = const [],
    String? imagePath,
  }) {
    return repository.saveMessage(
      conversationId: conversationId,
      text: text,
      isUser: isUser,
      refs: refs,
      imagePath: imagePath,
    );
  }
}
