import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../presenters/presenters.dart';
import '../../utils/utils.dart';
import '../../services/services.dart';

class AdjustedLineChart extends StatelessWidget {
  final LineChartData lineChartData;
  static List<List<double>> lastClosePriceAndSubsequentTrends = [];

  AdjustedLineChart({Key? key, LineChartData? lineChartData})
      : lineChartData = lineChartData ?? getDefaultLineChartData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < MainPresenter.to.matchRows.length; i++) {
      lastClosePriceAndSubsequentTrends.add(
          CloudService().getMatchedTrendLastClosePriceAndSubsequentTrend(i));
    }
    CloudService().getCsvAndPng(lastClosePriceAndSubsequentTrends);

    return SizedBox(
      width: 393.w,
      height: 200.h,
      child: LineChart(lineChartData),
    );
  }

  static List<FlSpot> getlineBarsData(int index) {
    List<FlSpot> flspotList = [];
    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

    double lastSelectedClosePrice =
        MainPresenter.to.listList[MainPresenter.to.listList.length - 1][4];

    double lastActualDifference =
        MainPresenter.to.listList[MainPresenter.to.listList.length - 1][4] /
            MainPresenter.to.listList[
                MainPresenter.to.matchRows[index] + selectedLength.toInt()][4];

    for (double i = 0; i < selectedLength * 2 + 2; i++) {
      if (i == selectedLength) {
        flspotList.add(FlSpot(i, lastSelectedClosePrice));
      } else {
        double adjustedMatchedTrendClosePrice = MainPresenter
                    .to.listList[MainPresenter.to.matchRows[index] + i.toInt()]
                [4] // Close price of matched trend
            *
            lastActualDifference;

        flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
      }
    }

    return flspotList;
  }

  static List<FlSpot> getSelectedPeriodClosePrices() {
    List<FlSpot> flspotList = [];

    for (int i = 0;
        i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      flspotList.add(FlSpot(
          i.toDouble(),
          MainPresenter.to.listList[MainPresenter.to.listList.length -
              MainPresenter.to.selectedPeriodPercentDifferencesList.length +
              i -
              1][4]));
    }

    return flspotList;
  }

  static LineChartData getDefaultLineChartData() {
    return LineChartData(
      borderData: FlBorderData(show: false),
      lineBarsData: MainPresenter.to.matchRows
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
