import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String _baseUrl = 'http://45.129.87.38:6065/user/login';

  Future<(String, UserModel)> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password, "role": role}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final String token = data['user']['_id'] as String;
      final UserModel user = UserModel.fromJson(data['user']);
      return (token, user); // ✅ Now it returns (String, UserModel)
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

}
