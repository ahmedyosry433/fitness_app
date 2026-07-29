import 'package:equatable/equatable.dart';

sealed class AiAgentIntent extends Equatable {
  const AiAgentIntent();

  @override
  List<Object?> get props => const [];
}

/// Loads the saved conversations for the side drawer.
class LoadConversationsIntent extends AiAgentIntent {
  const LoadConversationsIntent();
}

/// Opens the chat screen state for [conversationId], or a fresh chat when null.
class OpenConversationIntent extends AiAgentIntent {
  const OpenConversationIntent(this.conversationId);

  final int? conversationId;

  @override
  List<Object?> get props => [conversationId];
}

class StartNewConversationIntent extends AiAgentIntent {
  const StartNewConversationIntent();
}

class SendMessageIntent extends AiAgentIntent {
  const SendMessageIntent(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

/// Stages a picked image as the attachment for the next message.
class AttachImageIntent extends AiAgentIntent {
  const AttachImageIntent(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}

class ClearImageAttachmentIntent extends AiAgentIntent {
  const ClearImageAttachmentIntent();
}

class DeleteConversationIntent extends AiAgentIntent {
  const DeleteConversationIntent(this.conversationId);

  final int conversationId;

  @override
  List<Object?> get props => [conversationId];
}
