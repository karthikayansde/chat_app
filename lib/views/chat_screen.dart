import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../services/chat_service.dart';
import '../models/message_model.dart';
import '../viewmodels/chat/message_bloc.dart';
import '../viewmodels/chat/message_event.dart';
import '../viewmodels/chat/message_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId, required this.senderId});

  final String chatId;
  final String senderId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  late final MessageBloc _messageBloc;

  @override
  void initState() {
    super.initState();
    _messageBloc = MessageBloc(ChatService())..add(FetchMessages(widget.chatId));
  }

  @override
  void dispose() {
    _messageBloc.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _messageBloc,
      child: Scaffold(
        appBar: AppBar(title: Text("Chat")),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    print("State: MessageLoading");
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MessageLoaded) {
                    print("State: MessageLoaded with messages: ");
                    print(state.messages.map((msg) => msg.content).toList());
                    return state.messages.isEmpty?Center(
                      child: Text("No messages yet"),
                    ): ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (_, index) {
                        final msg =
                            state.messages[state.messages.length - index - 1];
                        return Align(
                          alignment: msg.senderId == widget.senderId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: msg.senderId == widget.senderId
                                  ? Colors.blue[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: msg.messageType == "file"
                                ? ChatImageAvatar(
                                    imageUrl:
                                        'http://45.129.87.38:6065/${msg.fileUrl}',
                                  )
                                : Text(msg.content),
                          ),
                        );
                      },
                    );
                  } else if (state is MessageError) {
                    print("State: MessageError with error: ");
                    print(state.error);
                    return Center(child: Text("Error: ${state.error}"));
                  }
                  print("State: Unknown");
                  return SizedBox();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: controller)),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        print("Sending message");
                        _messageBloc.add(
                          SendMessageEvent(
                            widget.chatId,
                            widget.senderId,
                            controller.text.trim(),
                          ),
                        );
                        controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatImageAvatar extends StatelessWidget {
  final String imageUrl;

  const ChatImageAvatar({super.key, required this.imageUrl});

  Future<bool> isImageAvailable(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 &&
          response.headers['content-type']?.startsWith('image/') == true) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isImageAvailable(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircleAvatar(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          return CircleAvatar(backgroundImage: NetworkImage(imageUrl));
        } else {
          return const CircleAvatar(child: Icon(Icons.image_not_supported));
        }
      },
    );
  }
}
