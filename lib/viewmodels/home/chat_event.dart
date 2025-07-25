abstract class ChatEvent {}

class LoadChats extends ChatEvent {
  final String userId;

  LoadChats(this.userId);
}
