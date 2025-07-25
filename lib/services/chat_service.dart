import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class ChatService {
  final String baseUrl = 'http://45.129.87.38:6065';

  Future<List<MessageModel>> fetchMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/messages/get-messagesformobile/$chatId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    final url = Uri.parse('$baseUrl/messages/sendMessage');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "chatId": chatId,
        "senderId": senderId,
        "content": content,
        "messageType": "text",
        "fileUrl": ""
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MessageModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }
}
