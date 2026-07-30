import 'package:equatable/equatable.dart';

/// Side effects the page performs on behalf of the cubit.
sealed class AiAgentNavigation extends Equatable {
  const AiAgentNavigation();

  @override
  List<Object?> get props => const [];
}

class OpenChatNavigation extends AiAgentNavigation {
  const OpenChatNavigation(this.conversationId);

  final int? conversationId;

  @override
  List<Object?> get props => [conversationId];
}

class ScrollToBottomNavigation extends AiAgentNavigation {
  const ScrollToBottomNavigation();
}
