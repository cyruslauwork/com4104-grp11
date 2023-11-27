import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../controllers/controllers.dart';
import '../../utils/utils.dart';

class AdjustedLineChart extends StatelessWidget {
  final LineChartData lineChartData;

  AdjustedLineChart({Key? key, LineChartData? lineChartData})
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

  static List<FlSpot> getlineBarsData(int index) {
    List<FlSpot> flspotList = [];

    double lastSelectedClosePrice = GlobalController
        .to.listList[GlobalController.to.listList.length - 1][4];

    double lastActualDifference = GlobalController
            .to.listList[GlobalController.to.listList.length - 1][4] -
        GlobalController.to.listList[GlobalController.to.matchRows[index] +
            GlobalController.to.selectedPeriodActualDifferencesList.length][4];

    for (double i = 0;
        i <
            GlobalController.to.selectedPeriodPercentDifferencesList.length *
                    2 +
                2;
        i++) {
      if (i ==
          GlobalController.to.selectedPeriodPercentDifferencesList.length) {
        flspotList.add(FlSpot(i, lastSelectedClosePrice));
      } else {
        double adjustedMatchedTrendClosePrice = GlobalController.to
                    .listList[GlobalController.to.matchRows[index] + i.toInt()]
                [4] // Close price of matched trend
            +
            lastActualDifference;

        flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
      }
    }

    return flspotList;
  }

  static List<FlSpot> getSelectedPeriodClosePrices() {
    List<FlSpot> flspotList = [];

    for (int i = 0;
        i < GlobalController.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      flspotList.add(FlSpot(
          i.toDouble(),
          GlobalController.to.listList[GlobalController.to.listList.length -
              GlobalController.to.selectedPeriodPercentDifferencesList.length +
              i -
              1][4]));
    }

    return flspotList;
  }

  static LineChartData getDefaultLineChartData() {
    return LineChartData(
      borderData: FlBorderData(show: false),
      lineBarsData: GlobalController.to.matchRows
          .mapIndexed((index, row) => LineChartBarData(
              spots: getlineBarsData(index),
              isCurved: true,
              barWidth: 1,
              color: Colors.grey))
          // .take(5) // Add this line to limit the items to the first 5
          .toList()
        ..add(
          LineChartBarData(
            spots: getSelectedPeriodClosePrices(),
            isCurved: true,
            barWidth: 3,
            color: Colors.red,
          ),
        ),
    );
  }
}
