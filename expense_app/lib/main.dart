import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/expense.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExpenseListScreen(),
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Future<List<Expense>> futureExpenses;

  @override
  void initState() {
    super.initState();
    futureExpenses = ApiService.fetchExpenses();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isIncome = false; // ✅ thêm biến này để chọn chi tiêu hay thu nhập

  void _addExpense() async {
    if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
      await ApiService.addExpense(
        titleController.text,
        double.parse(amountController.text),
        isIncome, // ✅ thêm tham số đúng với ApiService
      );
      setState(() {
        futureExpenses = ApiService.fetchExpenses();
      });
      titleController.clear();
      amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý chi tiêu")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Expense>>(
              future: futureExpenses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Chưa có dữ liệu"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final expense = snapshot.data![index];
                      return ListTile(
                        title: Text(expense.title),
                        subtitle: Text("Số tiền: ${expense.amount}"),
                        trailing: Text(
                          expense.date.toString(), // ✅ đổi createdAt thành date
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Tên chi tiêu"),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: "Số tiền"),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isIncome,
                      onChanged: (val) {
                        setState(() {
                          isIncome = val ?? false;
                        });
                      },
                    ),
                    Text("Là thu nhập"),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: Text("Thêm chi tiêu"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
