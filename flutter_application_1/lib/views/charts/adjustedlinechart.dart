import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_application_1/styles/theme.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/utils/utils.dart';

class AdjustedLineChart extends StatelessWidget {
  final LineChartData lineChartData;

  AdjustedLineChart({Key? key, LineChartData? lineChartData})
      : lineChartData = lineChartData ?? getDefaultAdjustedLineChartData(),
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

List<FlSpot> getAdjustedlineBarsData(int index) {
  List<FlSpot> flspotList = [];
  double selectedLength =
      MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

  double lastSelectedClosePrice = MainPresenter
      .to.candleListList[MainPresenter.to.candleListList.length - 1][4];

  double lastActualDifference = MainPresenter
          .to.candleListList[MainPresenter.to.candleListList.length - 1][4] /
      MainPresenter.to.candleListList[
          MainPresenter.to.matchRows[index] + selectedLength.toInt()][4];

  for (double i = 0; i < selectedLength * 2 + 2; i++) {
    if (i == selectedLength) {
      flspotList.add(FlSpot(i, lastSelectedClosePrice));
    } else {
      double adjustedMatchedTrendClosePrice = MainPresenter.to
                  .candleListList[MainPresenter.to.matchRows[index] + i.toInt()]
              [4] // Close price of matched trend
          *
          lastActualDifference;

      flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
    }
  }

  return flspotList;
}

List<FlSpot> getSelectedPeriodClosePrices() {
  List<FlSpot> flspotList = [];

  for (int i = 0;
      i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
      i++) {
    flspotList.add(FlSpot(
        i.toDouble(),
        MainPresenter.to.candleListList[MainPresenter.to.candleListList.length -
            MainPresenter.to.selectedPeriodPercentDifferencesList.length +
            i -
            1][4]));
  }

  return flspotList;
}

LineChartData getDefaultAdjustedLineChartData() {
  return LineChartData(
    borderData: FlBorderData(show: false),
    lineBarsData: MainPresenter.to.matchRows
        .mapIndexed((index, row) => LineChartBarData(
            spots: getAdjustedlineBarsData(index),
            isCurved: true,
            barWidth: 1,
            color: AppColor.greyColor))
        // .take(5) // Add this line to limit the items to the first 5
        .toList()
      ..add(
        LineChartBarData(
          spots: getSelectedPeriodClosePrices(),
          isCurved: true,
          barWidth: 3,
          color: AppColor.errorColor,
        ),
      ),
  );
}
