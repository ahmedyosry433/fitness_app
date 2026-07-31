import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'ai_chat_database.g.dart';

/// Local chat history: one row per conversation, one row per message.
class Conversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get conversationId =>
      integer().references(Conversations, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  BoolColumn get isUser => boolean()();

  /// Grounded refs serialised as a JSON array.
  TextColumn get refsJson => text().nullable()();

  /// Local file path of an image attached by the user.
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Conversations, ChatMessages])
@lazySingleton
class AiChatDatabase extends _$AiChatDatabase {
  AiChatDatabase()
    : super(
        driftDatabase(
          name: 'ai_agent_chat',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(chatMessages, chatMessages.imagePath);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<int> createConversation(String title) {
    return into(
      conversations,
    ).insert(ConversationsCompanion.insert(title: _normalizeTitle(title)));
  }

  Future<void> renameConversation(int conversationId, String title) {
    return (update(
      conversations,
    )..where((t) => t.id.equals(conversationId))).write(
      ConversationsCompanion(
        title: Value(_normalizeTitle(title)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> touchConversation(int conversationId) {
    return (update(conversations)..where((t) => t.id.equals(conversationId)))
        .write(ConversationsCompanion(updatedAt: Value(DateTime.now())));
  }

  Future<List<Conversation>> getConversations({int limit = 50}) {
    return (select(conversations)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(limit))
        .get();
  }

  Stream<List<Conversation>> watchConversations({int limit = 50}) {
    return (select(conversations)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(limit))
        .watch();
  }

  Future<int> insertMessage({
    required int conversationId,
    required String content,
    required bool isUser,
    String? refsJson,
    String? imagePath,
  }) async {
    final id = await into(chatMessages).insert(
      ChatMessagesCompanion.insert(
        conversationId: conversationId,
        content: content,
        isUser: isUser,
        refsJson: Value(refsJson),
        imagePath: Value(imagePath),
      ),
    );
    await touchConversation(conversationId);
    return id;
  }

  Future<void> updateMessage({
    required int messageId,
    required String content,
    String? refsJson,
  }) {
    return (update(chatMessages)..where((t) => t.id.equals(messageId))).write(
      ChatMessagesCompanion(content: Value(content), refsJson: Value(refsJson)),
    );
  }

  Future<List<ChatMessage>> getMessages(int conversationId) {
    return (select(chatMessages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  Future<void> deleteConversation(int conversationId) async {
    await (delete(
      chatMessages,
    )..where((t) => t.conversationId.equals(conversationId))).go();
    await (delete(
      conversations,
    )..where((t) => t.id.equals(conversationId))).go();
  }

  static String _normalizeTitle(String title) {
    final trimmed = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) return 'New conversation';
    return trimmed.length <= 60 ? trimmed : '${trimmed.substring(0, 57)}...';
  }
}
