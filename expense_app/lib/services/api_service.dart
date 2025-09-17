import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ApiService {
  // ⚠️ Nhớ bỏ dấu cách thừa sau http:// nếu có
  static const String baseUrl = "https://ed401fa5fc10.ngrok-free.app";
  // Nếu dùng máy ảo/emulator thì có thể là http://10.0.2.2:3000

  /// Lấy danh sách transactions
  static Future<List<Expense>> fetchExpenses() async {
    final response = await http.get(Uri.parse("$baseUrl/transactions"));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Expense.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load expenses");
    }
  }

  /// Thêm giao dịch mới
  static Future<Expense> addExpense(
      String title, double amount, bool isIncome) async {
    final response = await http.post(
      Uri.parse("$baseUrl/transactions"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": title,
        "amount": amount,
        "is_income": isIncome,
        "date": DateTime.now().toIso8601String(), // gửi ngày hiện tại
      }),
    );

    if (response.statusCode == 200) {
      return Expense.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add expense");
    }
  }

  /// Xóa giao dịch
  static Future<void> deleteExpense(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/transactions/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete expense");
    }
  }
}
