import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message_model.dart';

class ChatLocalDataSource {
  static const String _conversationsBoxName = 'chat_conversations';
  static const String _messagesBoxName = 'chat_messages';

  final Uuid _uuid = const Uuid();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatConversationAdapter());
    Hive.registerAdapter(ChatMessageModelAdapter());

    await Hive.openBox<ChatConversation>(_conversationsBoxName);
    await Hive.openBox<ChatMessageModel>(_messagesBoxName);
  }

  Box<ChatConversation> get _conversationsBox =>
      Hive.box<ChatConversation>(_conversationsBoxName);
  Box<ChatMessageModel> get _messagesBox =>
      Hive.box<ChatMessageModel>(_messagesBoxName);

  List<ChatConversation> getConversations(String userId) {
    final conversations = _conversationsBox.values
        .where((c) => c.userId == userId)
        .toList();
    conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return conversations;
  }

  List<ChatMessageModel> getMessages(String conversationId) {
    final messages = _messagesBox.values
        .where((msg) => msg.conversationId == conversationId)
        .toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  Future<ChatConversation> startNewConversation(
    String initialText,
    String userId,
  ) async {
    final String id = _uuid.v4();
    final String title = initialText.length > 30
        ? '${initialText.substring(0, 30)}...'
        : initialText;

    final conversation = ChatConversation(
      id: id,
      title: title,
      updatedAt: DateTime.now(),
      userId: userId,
    );

    await _conversationsBox.put(id, conversation);
    return conversation;
  }

  Future<void> saveMessage({
    required String conversationId,
    required String text,
    required bool isUser,
  }) async {
    final message = ChatMessageModel(
      conversationId: conversationId,
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
    );

    await _messagesBox.add(message);

    // Update conversation's updatedAt
    final conversation = _conversationsBox.get(conversationId);
    if (conversation != null) {
      conversation.updatedAt = DateTime.now();
      await conversation.save();
    }
  }

  Future<void> deleteConversation(String id) async {
    await _conversationsBox.delete(id);

    // Delete associated messages
    final keysToDelete = _messagesBox
        .toMap()
        .entries
        .where((entry) => entry.value.conversationId == id)
        .map((entry) => entry.key)
        .toList();

    await _messagesBox.deleteAll(keysToDelete);
  }
}
