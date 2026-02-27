import 'package:hive/hive.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 1)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String conversationId;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  ChatMessageModel({
    required this.conversationId,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
