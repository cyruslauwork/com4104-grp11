import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/controllers/controllers.dart';
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

List<FlSpot> getlineBarsData(int index) {
  List<FlSpot> flsportList = [];
  for (double i = 0; i < GlobalController.to.selectedPeriodCount.value; i++) {
    flsportList.add(FlSpot(
        i,
        GlobalController
            .to.listList[GlobalController.to.matchRows[index] + i.toInt()][4]));
  }
  return flsportList;
}

LineChartData getDefaultLineChartData() {
  return LineChartData(
    borderData: FlBorderData(show: false),
    lineBarsData: GlobalController.to.matchRows
        .mapIndexed((index, row) => LineChartBarData(
            spots: getlineBarsData(index),
            isCurved: true,
            barWidth: 1,
            color: Colors.grey))
        .take(5) // Add this line to limit the items to the first 5
        .toList(),
    // [
    //   // The red line
    //   LineChartBarData(
    //     spots:
    //         // const [
    //         //   FlSpot(1, 3.8),
    //         //   FlSpot(3, 1.9),
    //         //   FlSpot(6, 5),
    //         //   FlSpot(10, 3.3),
    //         //   FlSpot(13, 4.5),
    //         // ]
    //         getlineBarsData,
    //     isCurved: true,
    //     barWidth: 3,
    //     color: Colors.red,
    //   ),
    //   // The orange line
    //   LineChartBarData(
    //     spots:
    //         // const [
    //         //   FlSpot(1, 1),
    //         //   FlSpot(3, 2.8),
    //         //   FlSpot(7, 1.2),
    //         //   FlSpot(10, 2.8),
    //         //   FlSpot(12, 2.6),
    //         //   FlSpot(13, 3.9),
    //         // ]
    //         getlineBarsData,
    //     isCurved: true,
    //     barWidth: 3,
    //     color: Colors.orange,
    //   ),
    //   // The blue line
    //   LineChartBarData(
    //     spots:
    //         // const [
    //         //   FlSpot(1, 1),
    //         //   FlSpot(3, 4),
    //         //   FlSpot(5, 1.8),
    //         //   FlSpot(7, 5),
    //         //   FlSpot(10, 2),
    //         //   FlSpot(12, 2.2),
    //         //   FlSpot(13, 1.8),
    //         // ]
    //         getlineBarsData,
    //     isCurved: false,
    //     barWidth: 3,
    //     color: Colors.blue,
    //   ),
    // ],
  );
}
