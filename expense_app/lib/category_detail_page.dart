import 'package:flutter/material.dart';
import 'expense_pie_chart.dart';
import 'expense_bar_chart.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> allExpenses;

  const CategoryDetailPage({
    Key? key,
    required this.categoryName,
    required this.allExpenses,
  }) : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, double> getFilteredData(String filterType) {
    final Map<String, double> filtered = {};
    for (var exp in widget.allExpenses) {
      if (exp['category'] != widget.categoryName) continue;

      final DateTime d = exp['date'];
      bool match = false;

      if (filterType == 'Ngày') {
        match = d.year == _selectedDate.year &&
            d.month == _selectedDate.month &&
            d.day == _selectedDate.day;
      } else if (filterType == 'Tháng') {
        match = d.year == _selectedDate.year && d.month == _selectedDate.month;
      } else if (filterType == 'Năm') {
        match = d.year == _selectedDate.year;
      }

      if (match) {
        filtered[widget.categoryName] =
            (filtered[widget.categoryName] ?? 0) + exp['amount'];
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Ngày', 'Tháng', 'Năm'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ngày'),
            Tab(text: 'Tháng'),
            Tab(text: 'Năm'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tab) {
          final dataMap = getFilteredData(tab);
          double total = 0;
          dataMap.forEach((key, value) {
            total += value;
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // chọn ngày/tháng/năm
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextButton.icon(
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
                ),
              ),

              const SizedBox(height: 16),

              // Tổng chi
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Tổng chi cho ${widget.categoryName} ($tab)',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('${total.toStringAsFixed(0)} VNĐ',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Biểu đồ
              if (dataMap.isNotEmpty)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Biểu đồ chi cho ${widget.categoryName} ($tab)',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        ExpensePieChart(dataMap: dataMap),
                        // Hoặc BarChart
                        // ExpenseBarChart(dataMap: dataMap),
                      ],
                    ),
                  ),
                )
              else
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Không có dữ liệu cho thời gian này'))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
