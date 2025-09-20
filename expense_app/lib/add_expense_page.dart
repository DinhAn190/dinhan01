import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({Key? key}) : super(key: key);

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Ăn uống',
    'Tiền nhà',
    'Điện',
    'Nước',
    'Đi lại',
    'Quần áo',
    'Mỹ phẩm',
    'Chi tiêu khác',
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final double amount = double.parse(_amountController.text);
      final String note = _noteController.text;
      final String category = _selectedCategory!;

      // 🚀 Gửi dữ liệu lên API hoặc lưu DB tại đây
      print('Số tiền: $amount');
      print('Danh mục: $category');
      print('Ngày: $_selectedDate');
      print('Ghi chú: $note');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu khoản chi')),
      );

      Navigator.pop(context); // trở về HomePage sau khi lưu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm khoản chi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nhập số tiền
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Chọn danh mục
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn danh mục';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Chọn ngày
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ngày chi tiêu',
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      const Icon(Icons.edit_calendar, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ghi chú
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Nút lưu
              ElevatedButton.icon(
                onPressed: _saveExpense,
                icon: const Icon(Icons.save),
                label: const Text('Lưu khoản chi'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
