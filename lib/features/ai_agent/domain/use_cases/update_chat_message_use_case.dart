import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';
import 'package:fitness/features/ai_agent/domain/repositories/ai_chat_history_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateChatMessageUseCase {
  const UpdateChatMessageUseCase(this.repository);

  final AiChatHistoryRepository repository;

  Future<void> call({
    required int messageId,
    required String text,
    List<AiRefEntity> refs = const [],
  }) {
    return repository.updateMessage(
      messageId: messageId,
      text: text,
      refs: refs,
    );
  }
}
