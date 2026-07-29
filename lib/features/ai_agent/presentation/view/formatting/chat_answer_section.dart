import 'package:equatable/equatable.dart';

enum ChatBlockKind { paragraph, bullets }

/// One renderable piece inside a section.
class ChatAnswerBlock extends Equatable {
  const ChatAnswerBlock.paragraph(String this.text)
    : kind = ChatBlockKind.paragraph,
      items = const [];

  const ChatAnswerBlock.bullets(this.items)
    : kind = ChatBlockKind.bullets,
      text = null;

  final ChatBlockKind kind;
  final String? text;
  final List<String> items;

  @override
  List<Object?> get props => [kind, text, items];
}

/// A chunk of the answer that gets its own chat bubble: an optional title plus
/// the blocks that belong to it.
class ChatAnswerSection extends Equatable {
  const ChatAnswerSection({this.title, this.blocks = const []});

  final String? title;
  final List<ChatAnswerBlock> blocks;

  bool get isEmpty => (title == null || title!.isEmpty) && blocks.isEmpty;

  @override
  List<Object?> get props => [title, blocks];
}
