import 'package:chat_app/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/chat_service.dart';
import '../viewmodels/chat/message_bloc.dart';
import '../viewmodels/home/chat_bloc.dart';
import '../viewmodels/home/chat_event.dart';
import '../viewmodels/home/chat_state.dart';
import 'package:http/http.dart' as http;

import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(ChatRepository())..add(LoadChats(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text("No chats found"));
              }
              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  final otherParticipant = chat.participants.firstWhere(
                        (user) => user.id != userId,
                    orElse: () => chat.participants[0],
                  );
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => MessageBloc(ChatService()),
                            child: ChatScreen(chatId: chat.chatId??"",senderId: chat.senderId??'',),
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: ProfileAvatar(
                        imageUrl: "http://45.129.87.38:6065/uploads/${otherParticipant.profile}",
                      ),
                      title: Text(otherParticipant.name),
                      subtitle: Text(chat.lastMessage ?? "No messages yet"),
                    ),
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;

  const ProfileAvatar({super.key, required this.imageUrl});

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
          return CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          );
        } else {
          return const CircleAvatar(
            child: Icon(Icons.person),
          );
        }
      },
    );
  }
}