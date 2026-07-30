import 'package:equatable/equatable.dart';
import 'package:fitness/features/ai_agent/domain/entities/chat_message_entity.dart';

/// Everything the app knows about the signed-in user that is worth injecting
/// into the system prompt: the cached profile fields plus a compact recap of
/// the previous conversation, so the assistant keeps its memory across chats.
class AiUserContextEntity extends Equatable {
  const AiUserContextEntity({
    this.name,
    this.email,
    this.phone,
    this.previousChatTitle,
    this.previousChatDate,
    this.previousChatTurns = const [],
  });

  static const AiUserContextEntity empty = AiUserContextEntity();

  final String? name;
  final String? email;
  final String? phone;

  /// Title of the most recent conversation other than the current one.
  final String? previousChatTitle;
  final DateTime? previousChatDate;

  /// Already trimmed turns of that conversation, oldest first.
  final List<ChatMessageEntity> previousChatTurns;

  bool get hasProfile =>
      _isFilled(name) || _isFilled(email) || _isFilled(phone);

  bool get hasPreviousChat => previousChatTurns.isNotEmpty;

  bool get isEmpty => !hasProfile && !hasPreviousChat;

  AiUserContextEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? previousChatTitle,
    DateTime? previousChatDate,
    List<ChatMessageEntity>? previousChatTurns,
  }) {
    return AiUserContextEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      previousChatTitle: previousChatTitle ?? this.previousChatTitle,
      previousChatDate: previousChatDate ?? this.previousChatDate,
      previousChatTurns: previousChatTurns ?? this.previousChatTurns,
    );
  }

  static bool _isFilled(String? value) =>
      value != null && value.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    previousChatTitle,
    previousChatDate,
    previousChatTurns,
  ];
}
