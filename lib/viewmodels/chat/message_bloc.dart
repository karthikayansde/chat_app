import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatService chatService;
  List<MessageModel> messages = [];

  MessageBloc(this.chatService) : super(MessageInitial()) {
    on<FetchMessages>((event, emit) async {
      emit(MessageLoading());
      try {
        messages = await chatService.fetchMessages(event.chatId);
        emit(MessageLoaded(messages));
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        final newMessage = await chatService.sendMessage(
          chatId: event.chatId,
          senderId: event.senderId,
          content: event.content,
        );
        messages = List.from(messages)..add(newMessage); // Ensure immutability
        print("New message added: ");
        print(newMessage.content);
        emit(MessageLoaded(messages));
      } catch (e) {
        print("Error sending message: ");
        print(e);
        emit(MessageError(e.toString()));
      }
    });
  }
}
