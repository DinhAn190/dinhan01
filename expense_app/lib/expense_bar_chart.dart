import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseBarChart extends StatelessWidget {
  final Map<String, double> dataMap;

  const ExpenseBarChart({Key? key, required this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purpleAccent,
      Colors.teal,
    ];

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < dataMap.keys.length) {
                    return Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        dataMap.keys.elementAt(index),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: dataMap.entries.map((entry) {
            final index = dataMap.keys.toList().indexOf(entry.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value / 1000, // scale nhỏ nếu số tiền lớn
                  color: colors[index % colors.length],
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
