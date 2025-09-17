import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://abc123.ngrok-free.app"; // ngrok URL

  static Future<String> register(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return "Đăng ký thành công";
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["token"]; // lưu token lại để dùng cho API khác
    } else {
      throw Exception(response.body);
    }
  }
}
