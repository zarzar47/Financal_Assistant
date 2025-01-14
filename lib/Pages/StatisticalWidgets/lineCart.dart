import 'package:finance_app/backend_API.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CumulativeLineGraph extends StatelessWidget {
  final List<TransactionInfo> transactions;

  CumulativeLineGraph(this.transactions);

  @override
  Widget build(BuildContext context) {
    // Sort transactions by date
    transactions.sort((a, b) {
      DateTime dateA = _parseDate(a.date);
      DateTime dateB = _parseDate(b.date);
      return dateA.compareTo(dateB);
    });

    // Calculate cumulative spending
    List<double> cumulativeSpending = [];
    double total = 0.0;

    for (var transaction in transactions) {
      total += transaction.price;
      cumulativeSpending.add(total);
    }

    // Prepare line chart data
    List<FlSpot> spots = [];
    for (int i = 0; i < cumulativeSpending.length; i++) {
      spots.add(FlSpot(i.toDouble(), cumulativeSpending[i]));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 300,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  String val = value.toStringAsFixed(0);
                  return Text(
                    val,
                    style: const TextStyle(
                      fontSize: 15, // Adjust font size for clarity
                      color: Colors.blue,
                    ),
                  );
                },
              )),
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: false,
              )),
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: false,
              )),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    String formattedValue = _formatValue(value);
                    return Text(
                      formattedValue,
                      style: const TextStyle(
                        fontSize: 15, // Adjust font size for clarity
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k'; // For example, 60000 -> 60.0k
    } else {
      return value.toStringAsFixed(
          0); // For smaller numbers, display as-is (e.g., 500 -> 500)
    }
  }

  // Helper to parse date from the transaction
  DateTime _parseDate(String date) {
    List<String> parts = date.split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  // Helper to format date for display
  String _formatDate(String date) {
    DateTime parsedDate = _parseDate(date);
    return '${parsedDate.day}/${parsedDate.month}';
  }
}
