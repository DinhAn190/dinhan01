import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() => runApp(ExpenseApp());

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý chi tiêu',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      home: LoginPage(),
    );
  }
}

class ExpenseHomeScreen extends StatefulWidget {
  @override
  State<ExpenseHomeScreen> createState() => _ExpenseHomeScreenState();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  final List<Map<String, dynamic>> _transactions = [];

  void _addTransaction(Map<String, dynamic> t) {
    setState(() {
      _transactions.add(t);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý chi tiêu')),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (ctx, i) {
          final t = _transactions[i];
          return Card(
            child: ListTile(
              leading: Icon(Icons.category),
              title: Text('${t['category']} - ${t['amount']}đ'),
              subtitle: Text('${t['date']} | ${t['note']}'),
              trailing: Text(
                t['type'] == 'expense' ? '-${t['amount']}' : '+${t['amount']}',
                style: TextStyle(
                    color: t['type'] == 'expense' ? Colors.red : Colors.green),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTransactionScreen()),
          );
          if (result != null) _addTransaction(result);
        },
      ),
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime _date = DateTime.now();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'expense';
  String? _selectedCategory;

  final List<String> _categories = [
    'Ăn uống',
    'Tiền điện',
    'Tiền nước',
    'Mua sắm',
    'Đi lại',
    'Quần áo',
    'Mỹ phẩm',
    'Khác'
  ];

  void _save() {
    if (_selectedCategory == null || _amountController.text.isEmpty) return;
    Navigator.pop(context, {
      'category': _selectedCategory,
      'amount': double.tryParse(_amountController.text) ?? 0,
      'date': _date.toIso8601String().substring(0, 10),
      'note': _noteController.text,
      'type': _type,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập khoản chi')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ngày: ${_date.toLocal().toString().substring(0, 10)}'),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Text('Chọn ngày'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Ghi chú'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Danh mục'),
              value: _selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Chi tiêu'),
                    value: 'expense',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Thu nhập'),
                    value: 'income',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text('Lưu giao dịch'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40)),
            ),
          ],
        ),
      ),
    );
  }
}
