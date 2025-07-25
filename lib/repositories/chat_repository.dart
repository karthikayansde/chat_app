import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chat_model.dart';

class ChatRepository {
  Future<List<ChatModel>> getUserChats(String userId) async {
    final response = await http.get(
      Uri.parse('http://45.129.87.38:6065/chats/user-chats/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => ChatModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }
}
