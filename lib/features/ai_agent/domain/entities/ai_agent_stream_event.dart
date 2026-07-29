import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';

enum AiAgentStreamEventType { token, refs, done, error }

/// Incremental output of one assistant turn.
class AiAgentStreamEvent {
  const AiAgentStreamEvent.token(String this.content)
    : type = AiAgentStreamEventType.token,
      refs = const [];

  const AiAgentStreamEvent.refs(this.refs)
    : type = AiAgentStreamEventType.refs,
      content = null;

  const AiAgentStreamEvent.done()
    : type = AiAgentStreamEventType.done,
      content = null,
      refs = const [];

  const AiAgentStreamEvent.error(String this.content)
    : type = AiAgentStreamEventType.error,
      refs = const [];

  final AiAgentStreamEventType type;
  final String? content;
  final List<AiRefEntity> refs;
}
