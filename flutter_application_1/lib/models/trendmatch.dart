import 'package:collection/collection.dart';
import 'dart:math';

import 'package:interactive_chart/interactive_chart.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/styles/styles.dart';

class TrendMatch {
  // Singleton implementation
  static final TrendMatch _instance = TrendMatch._();
  factory TrendMatch() => _instance;
  TrendMatch._();

  init() {
    MainPresenter.to.trendMatched.value = false;

    List<CandleData> listCandledata = MainPresenter.to.listCandledata;

    List<double> selectedPeriodPercentageDifferencesList = [];
    List<double> selectedPeriodActualDifferencesList = [];
    List<double> selectedPeriodActualPricesList = [];

    List<double> comparePeriodPercentageDifferencesList = [];
    List<double> comparePeriodActualDifferencesList = [];
    List<double> comparePeriodActualPricesList = [];

    List<List<double>> comparePeriodPercentageDifferencesListList = [];
    List<List<double>> comparePeriodActualDifferencesListList = [];
    List<List<double>> comparePeriodActualPricesListList = [];

    // List<double> matchPercentDifferencesList = [];
    List<double> matchActualDifferencesList = [];
    List<double> matchActualPricesList = [];

    List<List<double>> matchPercentDifferencesListList = [];
    List<List<double>> matchActualDifferencesListList = [];
    List<List<double>> matchActualPricesListList = [];

    MainPresenter.to.adjustedTrendsAndSelectedTrendList.value = [];

    int trueCount = 0;
    int falseCount = 0;
    int range = MainPresenter.to.range.value;

    if (range <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    MainPresenter.to.matchRows.value = [];
    MainPresenter.to.matchPercentDifferencesListList.value = [];
    MainPresenter.to.matchActualDifferencesListList.value = [];
    MainPresenter.to.matchActualPricesListList.value = [];

    // Loop selected data
    for (int i = range; i > 1; i--) {
      double percentage =
          (listCandledata[listCandledata.length - (i - 1)].close! -
                  listCandledata[listCandledata.length - i].close!) /
              (listCandledata[listCandledata.length - i].close!);
      selectedPeriodPercentageDifferencesList.add(percentage);

      selectedPeriodActualDifferencesList.add(
          listCandledata[listCandledata.length - (i - 1)].close! -
              listCandledata[listCandledata.length - i].close!);
    }
    for (int i = range; i > 0; i--) {
      selectedPeriodActualPricesList
          .add(listCandledata[listCandledata.length - i].close!);
    }

    MainPresenter.to.selectedPeriodPercentDifferencesList.value =
        selectedPeriodPercentageDifferencesList;
    MainPresenter.to.selectedPeriodActualDifferencesList.value =
        selectedPeriodActualDifferencesList;
    MainPresenter.to.selectedPeriodActualPricesList.value =
        selectedPeriodActualPricesList;

    // Loop all data
    for (int l = 0; l < listCandledata.length - range * 2; l++) {
      // Minus selectedCount to avoid counting selected data as a same match
      for (int i = 0; i < range - 1; i++) {
        double percentage = (listCandledata[l + (i + 1)].close! -
                listCandledata[l + i].close!) /
            (listCandledata[l + i].close!);
        comparePeriodPercentageDifferencesList.add(percentage);
        comparePeriodActualDifferencesList.add(
            listCandledata[l + (i + 1)].close! - listCandledata[l + i].close!);
      }
      for (int i = 0; i < range; i++) {
        comparePeriodActualPricesList.add(listCandledata[l + i].close!);
      }

      (
        bool,
        List<double>
      ) comparisonResult = areDifferencesLessThanOrEqualToCertainPercent(
          selectedPeriodPercentageDifferencesList,
          comparePeriodPercentageDifferencesList); // Record data type in Dart is equivalent to Tuple in Java and Python

      if (comparisonResult.$1) {
        trueCount += 1;

        MainPresenter.to.matchRows.add(l);
        matchPercentDifferencesListList.add(comparisonResult.$2);

        for (int i = 0; i < comparisonResult.$2.length; i++) {
          double actual =
              listCandledata[l + (i + 1)].close! - listCandledata[l + i].close!;
          matchActualDifferencesList.add(actual);
        }

        for (int i = 0; i < comparisonResult.$2.length + 1; i++) {
          matchActualPricesList.add(listCandledata[l + i].close!);
        }

        matchActualDifferencesListList.add(matchActualDifferencesList);
        matchActualPricesListList.add(matchActualPricesList);
      } else {
        falseCount += 1;
      }

      comparePeriodPercentageDifferencesListList
          .add(comparePeriodPercentageDifferencesList);
      comparePeriodActualDifferencesListList
          .add(comparePeriodActualDifferencesList);
      comparePeriodActualPricesListList.add(comparePeriodActualPricesList);
      comparePeriodPercentageDifferencesList = [];
      comparePeriodActualDifferencesList = [];
      comparePeriodActualPricesList = [];

      matchActualDifferencesList = [];
      matchActualPricesList = [];
    }

    MainPresenter.to.comparePeriodPercentDifferencesListList.value =
        comparePeriodPercentageDifferencesListList;
    MainPresenter.to.comparePeriodActualDifferencesListList.value =
        comparePeriodActualDifferencesListList;
    MainPresenter.to.comparePeriodActualPricesListList.value =
        comparePeriodActualPricesListList;

    MainPresenter.to.matchPercentDifferencesListList.value =
        matchPercentDifferencesListList;
    MainPresenter.to.matchActualDifferencesListList.value =
        matchActualDifferencesListList;
    MainPresenter.to.matchActualPricesListList.value =
        matchActualPricesListList;

    MainPresenter.to.lastCandledataLength.value = listCandledata.length;

    DateTime endTime = DateTime.now(); // Record the end time
    // Calculate the time difference
    Duration executionDuration = endTime.difference(startTime);
    int executionTime = executionDuration.inMilliseconds;

    MainPresenter.to.trendMatchOutput.value = [
      trueCount,
      falseCount,
      executionTime,
      listCandledata.length,
      range,
    ];

    MainPresenter.to.trendMatched.value = true;
  }

  (bool, List<double>) areDifferencesLessThanOrEqualToCertainPercent(
      List<double> selList, List<double> comList) {
    if (selList.length != comList.length) {
      // logger.d('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    for (int i = 0; i < selList.length; i++) {
      double difference = comList[i] - selList[i];
      double percentageDifference = (difference / selList[i]) * 100;

      if (percentageDifference.abs() >= MainPresenter.to.tolerance.value) {
        return (false, []); // Difference is larger than or equal to certain %
      }
    }

    return (true, comList); // All differences are less than certain %
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
          closePrices.add(MainPresenter.to.candleListList[// The CSV/JSON data
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
        double closePrice = MainPresenter.to.candleListList[// The CSV/JSON data
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
            MainPresenter.to.candleListList[// The CSV/JSON data
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
              color: AppColor.greyColor))
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
        double adjustedMatchedTrendClosePrice = MainPresenter.to.candleListList[
                    MainPresenter.to.matchRows[index] + i.toInt()]
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

    List<List<dynamic>> candleListList = MainPresenter.to.candleListList;

    for (int i = 0;
        i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      flspotList.add(FlSpot(
          i.toDouble(),
          candleListList[MainPresenter.to.candleListList.length -
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
              color: ThemeColor.secondary.value))
          // .take(5) // Add this line to limit the items to the first 5
          .toList()
        ..add(
          LineChartBarData(
            spots: getSelectedPeriodClosePrices(),
            isCurved: true,
            barWidth: 3,
            color: ThemeColor.primary.value,
          ),
        ),
      titlesData: const FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
    );
  }
}
