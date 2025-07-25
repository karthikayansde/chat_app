abstract class MessageEvent {}

class FetchMessages extends MessageEvent {
  final String chatId;
  FetchMessages(this.chatId);
}

class SendMessageEvent extends MessageEvent {
  final String chatId;
  final String senderId;
  final String content;

  SendMessageEvent(this.chatId, this.senderId, this.content);
}
