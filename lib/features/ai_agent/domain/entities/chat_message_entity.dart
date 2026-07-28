import 'package:equatable/equatable.dart';
import 'package:fitness/features/ai_agent/domain/entities/ai_ref_entity.dart';

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.text,
    required this.isUser,
    this.id,
    this.refs = const [],
    this.imagePath,
  });

  final int? id;
  final String text;
  final bool isUser;
  final List<AiRefEntity> refs;

  /// Local path of an image the user attached to this message.
  final String? imagePath;

  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  ChatMessageEntity copyWith({
    int? id,
    String? text,
    bool? isUser,
    List<AiRefEntity>? refs,
    String? imagePath,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      refs: refs ?? this.refs,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  /// Shape expected by the Ollama `messages` array.
  Map<String, dynamic> toChatTurn() => {
    'role': isUser ? 'user' : 'assistant',
    'content': text,
  };

  @override
  List<Object?> get props => [id, text, isUser, refs, imagePath];
}
