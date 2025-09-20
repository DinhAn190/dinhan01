import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  const ExpensePieChart({Key? key, required this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = dataMap.values.fold(0.0, (a, b) => a + b);
    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purpleAccent,
      Colors.teal,
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: dataMap.entries.map((entry) {
                final index = dataMap.keys.toList().indexOf(entry.key);
                final value = entry.value;
                final percent = (value / total) * 100;

                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: value,
                  title: '${percent.toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Hiển thị legend
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: dataMap.keys.map((key) {
            final index = dataMap.keys.toList().indexOf(key);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: colors[index % colors.length],
                ),
                const SizedBox(width: 4),
                Text(key),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
