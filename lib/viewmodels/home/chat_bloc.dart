import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await chatRepository.getUserChats(event.userId);
        emit(ChatLoaded(chats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
