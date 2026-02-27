import 'package:hive/hive.dart';

part 'chat_conversation.g.dart';

@HiveType(typeId: 0)
class ChatConversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  DateTime updatedAt;

  @HiveField(3, defaultValue: '')
  final String userId;

  ChatConversation({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.userId,
  });
}
