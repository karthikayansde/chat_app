import 'home_user_model.dart';

class ChatModel {
  final String id;

  final String? chatId;
  final String? senderId;

  final List<HomeUserModel> participants;
  final String? lastMessage;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
     this.chatId, this.senderId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["_id"],
      senderId: json["lastMessage"]["senderId"],
        chatId: json["lastMessage"]["_id"],
      participants: (json["participants"] as List)
          .map((e) => HomeUserModel.fromJson(e))
          .toList(),
      lastMessage: json["lastMessage"]?["content"],
    );
  }
}
