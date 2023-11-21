import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/utils.dart';

class MyLineChart extends StatelessWidget {
  final LineChartData lineChartData;

  MyLineChart({Key? key, LineChartData? lineChartData})
      : lineChartData = lineChartData ?? getDefaultLineChartData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393.w,
      height: 200.h,
      child: LineChart(lineChartData),
    );
  }
}

LineChartData getDefaultLineChartData() {
  return LineChartData(
    borderData: FlBorderData(show: false),
    lineBarsData: [
      // The red line
      LineChartBarData(
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
        isCurved: true,
        barWidth: 3,
        color: Colors.red,
      ),
      // The orange line
      LineChartBarData(
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
        isCurved: true,
        barWidth: 3,
        color: Colors.orange,
      ),
      // The blue line
      LineChartBarData(
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
        isCurved: false,
        barWidth: 3,
        color: Colors.blue,
      ),
    ],
  );
}
