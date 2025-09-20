import 'package:flutter/material.dart';
import 'login_page.dart';
import 'category_detail_page.dart';
import 'add_expense_page.dart';
import 'expense_pie_chart.dart';
import 'expense_bar_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(), // ← HomePage bên trong MaterialApp
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // tab index
  String _filterType = 'Tháng';
  DateTime _selectedDate = DateTime.now();

  // dữ liệu mẫu
  final List<Map<String, dynamic>> _expenses = [
    {'category': 'Ăn uống', 'amount': 200000, 'date': DateTime(2025, 9, 15)},
    {'category': 'Tiền nhà', 'amount': 3000000, 'date': DateTime(2025, 9, 1)},
    {'category': 'Điện', 'amount': 800000, 'date': DateTime(2025, 8, 30)},
    {'category': 'Nước', 'amount': 400000, 'date': DateTime(2025, 9, 15)},
    {'category': 'Đi lại', 'amount': 1000000, 'date': DateTime(2025, 9, 14)},
  ];

  // dữ liệu kế hoạch
  final List<Map<String, dynamic>> _plans = [];
  String _planType = 'Tháng';
  final TextEditingController _planAmountController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.fastfood, 'label': 'Ăn uống'},
    {'icon': Icons.shopping_cart, 'label': 'Chi tiêu khác'},
    {'icon': Icons.shopping_bag, 'label': 'Quần áo'},
    {'icon': Icons.face, 'label': 'Mỹ phẩm'},
    {'icon': Icons.home, 'label': 'Tiền nhà'},
    {'icon': Icons.directions_bus, 'label': 'Phí đi lại'},
    {'icon': Icons.electrical_services, 'label': 'Tiền điện'},
    {'icon': Icons.water_drop, 'label': 'Tiền nước'},
  ];

  Map<String, double> getFilteredData() {
    final Map<String, double> filtered = {};
    for (var exp in _expenses) {
      final DateTime d = exp['date'];
      bool match = false;
      if (_filterType == 'Ngày') {
        match = d.year == _selectedDate.year &&
            d.month == _selectedDate.month &&
            d.day == _selectedDate.day;
      } else if (_filterType == 'Tháng') {
        match = d.year == _selectedDate.year && d.month == _selectedDate.month;
      } else if (_filterType == 'Năm') {
        match = d.year == _selectedDate.year;
      }

      if (match) {
        final cat = exp['category'];
        filtered[cat] = (filtered[cat] ?? 0) + exp['amount'];
      }
    }
    return filtered;
  }

  // Tab Trang chủ
  Widget _buildHomeTab(BuildContext context) {
    final expenseData = getFilteredData();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bộ lọc thời gian
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _filterType,
                  underline: Container(),
                  items: ['Ngày', 'Tháng', 'Năm']
                      .map((value) =>
                      DropdownMenuItem<String>(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _filterType = newValue!;
                    });
                  },
                ),
                TextButton.icon(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        // Biểu đồ tròn
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Biểu đồ chi tiêu',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ExpensePieChart(dataMap: expenseData),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        // Biểu đồ cột
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Chi tiêu theo danh mục',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ExpenseBarChart(dataMap: expenseData),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        // Grid danh mục
        Text('Danh mục khoản chi',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final item = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailPage(
                          categoryName: item['label'],
                          allExpenses: _expenses,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Icon(item['icon'], color: Colors.deepPurple),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Tab Quản lý
  Widget _buildManageTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final exp = _expenses[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.money, color: Colors.deepPurple),
            title: Text(exp['category']),
            subtitle: Text(
                'Ngày: ${exp['date'].day}/${exp['date'].month}/${exp['date'].year}'),
            trailing: Text('${exp['amount']} đ'),
          ),
        );
      },
    );
  }

  // Tab Kế hoạch
  Widget _buildPlanTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tạo kế hoạch chi tiêu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: _planType,
                  underline: Container(),
                  items: ['Ngày', 'Tháng', 'Năm']
                      .map((value) =>
                      DropdownMenuItem<String>(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _planType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _planAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Số tiền kế hoạch (đ)',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_planAmountController.text.isEmpty) return;
                    setState(() {
                      _plans.add({
                        'type': _planType,
                        'amount': int.tryParse(_planAmountController.text) ?? 0,
                        'date': DateTime.now()
                      });
                      _planAmountController.clear();
                    });
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu kế hoạch'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Danh sách kế hoạch', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ..._plans.map((plan) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading:
            const Icon(Icons.calendar_today, color: Colors.deepPurple),
            title: Text('Loại: ${plan['type']}'),
            subtitle: Text(
                'Ngày tạo: ${plan['date'].day}/${plan['date'].month}/${plan['date'].year}'),
            trailing: Text('${plan['amount']} đ'),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHomeTab(context),
      _buildManageTab(context),
      _buildPlanTab(context),
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Tên người dùng'),
              accountEmail: Text('email@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Hồ sơ'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(['Trang chủ', 'Quản lý', 'Kế hoạch'][_currentIndex]),
        backgroundColor: Colors.deepPurple,
      ),
      body: tabs[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Quản lý'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Kế hoạch'),
        ],
      ),
    );
  }
}
