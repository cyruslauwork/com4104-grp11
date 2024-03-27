import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../presenters/presenters.dart';
import '../../utils/utils.dart';

class SimpleLineChart extends StatelessWidget {
  final LineChartData lineChartData;
  final bool normalized;

  SimpleLineChart({Key? key, LineChartData? lineChartData, bool? normalized})
      : lineChartData =
            lineChartData ?? getDefaultSimpleLineChartData(normalized ?? false),
        normalized = normalized ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393.w,
      height: 100.h,
      child: LineChart(lineChartData),
    );
  }
}

List<FlSpot> getSimplelineBarsData(int index, bool normalized) {
  List<FlSpot> flsportList = [];

// Whether to normalize
  if (normalized) {
    List<double> closePrices = [];

    for (int l = 0; l < MainPresenter.to.matchRows.length; l++) {
      for (int i = 0;
          i < MainPresenter.to.selectedPeriodPercentDifferencesList.length;
          i++) {
        closePrices.add(MainPresenter.to.listList[// The CSV/JSON data
            MainPresenter.to.matchRows[l] +
                i // Loop all closing prices in the matched trend
            ][4]); // The 4th row of the list is the closing price
      }
    }

    final lower = closePrices.reduce(min);
    final upper = closePrices.reduce(max);

    for (double i = 0;
        i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      double closePrice = MainPresenter.to.listList[// The CSV/JSON data
              MainPresenter.to.matchRows[
                      index] // Get the matched trend row from this index
                  +
                  i.toInt()] // Loop all closing prices in the matched trend
          [4]; // The 4th row of the list is the closing price
      if (closePrice < 0) {
        closePrice = -(closePrice / lower);
      } else {
        closePrice = closePrice / upper;
      }

      flsportList.add(FlSpot(
          i, // Equal to selectedPeriodCount, starting from 0
          closePrice));
    }
  } else {
    for (double i = 0;
        i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      flsportList.add(FlSpot(
          i, // Equal to selectedPeriodCount, starting from 0
          MainPresenter.to.listList[// The CSV/JSON data
                  MainPresenter.to.matchRows[
                          index] // Get the matched trend row from this index
                      +
                      i.toInt()] // Loop all closing prices in the matched trend
              [4] // The 4th row of the list is the closing price
          ));
    }
  }

  return flsportList;
}

LineChartData getDefaultSimpleLineChartData(bool normalized) {
  return LineChartData(
    borderData: FlBorderData(show: false),
    lineBarsData: MainPresenter.to.matchRows
        .mapIndexed((index, row) => LineChartBarData(
            spots: getSimplelineBarsData(index, normalized),
            isCurved: true,
            barWidth: 1,
            color: Colors.grey))
        // .take(5) // Add this line to limit the items to the first 5
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
