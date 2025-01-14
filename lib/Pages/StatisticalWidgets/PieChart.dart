import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  CategoryPieChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = data.entries.map((entry) {
      return PieChartSectionData(
        showTitle: true,
        value: entry.value,
        title: entry.key,
        color: Colors.primaries[
            data.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 60,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 300, // Specify height
        width: 300, // Specify width
        child: PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 40,
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }
}
