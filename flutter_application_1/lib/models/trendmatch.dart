import 'package:collection/collection.dart';
import 'dart:math';

import 'package:interactive_chart/interactive_chart.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/styles/styles.dart';

import 'package:flutter_application_1/utils/utils.dart';

class TrendMatch {
  // Singleton implementation
  static final TrendMatch _instance = TrendMatch._();
  factory TrendMatch() => _instance;
  TrendMatch._();

  init({required bool init}) {
    MainPresenter.to.trendMatched.value = false;

    List<CandleData> listCandledata = MainPresenter.to.listCandledata;
    // logger.d(listCandledata.length.toString());

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

    int trueCount = 0;
    int falseCount = 0;
    int range = MainPresenter.to.range.value;

    if (range <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    // init is false if and only if added new JSON data
    try {
      if (init) {
        try {
          MainPresenter.to.matchRows.value = [];
          MainPresenter.to.matchPercentDifferencesListList.value = [];
          MainPresenter.to.matchActualDifferencesListList.value = [];
          MainPresenter.to.matchActualPricesListList.value = [];
        } catch (e) {
          logger.d('1.1: An error occurred: $e');
        }

        // Loop selected data
        try {
          for (int i = range; i > 1; i--) {
            try {
              double percentage =
                  (listCandledata[listCandledata.length - (i - 1)].close! -
                          listCandledata[listCandledata.length - i].close!) /
                      (listCandledata[listCandledata.length - i].close!);
              selectedPeriodPercentageDifferencesList.add(percentage);
            } catch (e) {
              logger.d('1.3: An error occurred: $e');
            }
            try {
              selectedPeriodActualDifferencesList.add(
                  listCandledata[listCandledata.length - (i - 1)].close! -
                      listCandledata[listCandledata.length - i].close!);
            } catch (e) {
              logger.d('1.4: An error occurred: $e');
            }
          }
        } catch (e) {
          logger.d('1.2: An error occurred: $e');
        }
        try {
          for (int i = range; i > 0; i--) {
            try {
              selectedPeriodActualPricesList
                  .add(listCandledata[listCandledata.length - i].close!);
            } catch (e) {
              logger.d('1.6: An error occurred: $e');
            }
          }
        } catch (e) {
          logger.d('1.5: An error occurred: $e');
        }
        // logger.d('selected data: ${selectedPeriodList.length}');
        try {
          MainPresenter.to.selectedPeriodPercentDifferencesList.value =
              selectedPeriodPercentageDifferencesList;
          MainPresenter.to.selectedPeriodActualDifferencesList.value =
              selectedPeriodActualDifferencesList;
          MainPresenter.to.selectedPeriodActualPricesList.value =
              selectedPeriodActualPricesList;
        } catch (e) {
          logger.d('1.7: An error occurred: $e');
        }
        // difference between start and user selected date --> l
        // user selected range
        // --> 整daterange field
        // for (int i = 0; i < selectedCount - 1; i++) {
        //   double percentage =
        //       (listCandledata[l + (i + 1)].close! - listCandledata[l + i].close!) /
        //           (listCandledata[l + i].close!);
        //   selectedPeriodList.add(percentage);
        // }
      }
    } catch (e) {
      logger.d('1: An error occurred: $e');
    }
    // else {
    //   selectedPeriodPercentageDifferencesList =
    //       MainPresenter.to.selectedPeriodPercentDifferencesList;
    //   selectedPeriodActualDifferencesList =
    //       MainPresenter.to.selectedPeriodActualDifferencesList;
    //   selectedPeriodActualPricesList =
    //       MainPresenter.to.selectedPeriodActualPricesList;
    // }

    // Loop all data
    // logger.d('listCandledata: ${listCandledata.length}');
    try {
      for (int l = 0;
          l <
              (init
                  ? listCandledata.length - range * 2
                  : listCandledata.length -
                      MainPresenter.to.lastCandledataLength
                          .value); // init is false if and only if added new JSON data
          l++) {
        try {
          // Minus selectedCount to avoid counting selected data as a same match
          for (int i = 0; i < range - 1; i++) {
            try {
              double percentage = (listCandledata[l + (i + 1)].close! -
                      listCandledata[l + i].close!) /
                  (listCandledata[l + i].close!);
              comparePeriodPercentageDifferencesList.add(percentage);
            } catch (e) {
              logger.d('2.2: An error occurred: $e');
            }
            try {
              comparePeriodActualDifferencesList.add(
                  listCandledata[l + (i + 1)].close! -
                      listCandledata[l + i].close!);
            } catch (e) {
              logger.d('2.3: An error occurred: $e');
            }
          }
        } catch (e) {
          logger.d('2.1: An error occurred: $e');
        }
        try {
          for (int i = 0; i < range; i++) {
            try {
              comparePeriodActualPricesList.add(listCandledata[l + i].close!);
            } catch (e) {
              logger.d('2.5: An error occurred: $e');
            }
          }
          // logger.d('all data: ${comparePeriodList.length}');
        } catch (e) {
          logger.d('2.4: An error occurred: $e');
        }
        try {
          (
            bool,
            List<double>
          ) comparisonResult = areDifferencesLessThanOrEqualToCertainPercent(
              selectedPeriodPercentageDifferencesList,
              comparePeriodPercentageDifferencesList); // Record data type in Dart is equivalent to Tuple in Java and Python

          try {
            if (comparisonResult.$1) {
              trueCount += 1;

              // matchPercentDifferencesList = comparePeriodPercentageDifferencesList;
              try {
                MainPresenter.to.matchRows.add(l);
                matchPercentDifferencesListList.add(comparisonResult.$2);
              } catch (e) {
                logger.d('2.8: An error occurred: $e');
              }
              try {
                for (int i = 0; i < comparisonResult.$2.length; i++) {
                  try {
                    double actual = listCandledata[l + (i + 1)].close! -
                        listCandledata[l + i].close!;
                    matchActualDifferencesList.add(actual);
                  } catch (e) {
                    logger.d('2.9.1: An error occurred: $e');
                  }
                }
              } catch (e) {
                logger.d('2.9: An error occurred: $e');
              }
              try {
                for (int i = 0; i < comparisonResult.$2.length + 1; i++) {
                  try {
                    matchActualPricesList.add(listCandledata[l + i].close!);
                  } catch (e) {
                    logger.d('2.9.3: An error occurred: $e');
                  }
                }
              } catch (e) {
                logger.d('2.9.2: An error occurred: $e');
              }
              try {
                matchActualDifferencesListList.add(matchActualDifferencesList);
                matchActualPricesListList.add(matchActualPricesList);
              } catch (e) {
                logger.d('2.9.4: An error occurred: $e');
              }
            } else {
              falseCount += 1;
            }
          } catch (e) {
            logger.d('2.7: An error occurred: $e');
          }
        } catch (e) {
          logger.d('2.6: An error occurred: $e');
        }
        try {
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
        } catch (e) {
          logger.d('2.9.4: An error occurred: $e');
        }
      }
    } catch (e) {
      logger.d('2: An error occurred: $e');
    }

    try {
      // init is false if and only if added new JSON data
      if (init) {
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
      }
    } catch (e) {
      logger.d('3: An error occurred: $e');
    }
    // else {
    //   // Insert each row of new JSON data into the original list
    //   for (List<double> comparePeriodPercentageList
    //       in comparePeriodPercentageDifferencesListList.reversed) {
    //     MainPresenter.to.comparePeriodPercentDifferencesListList
    //         .insert(0, comparePeriodPercentageList);
    //   }
    //   // Insert each row of new JSON data into the original list
    //   for (List<double> comparePeriodActualDifferencesList
    //       in comparePeriodActualDifferencesListList.reversed) {
    //     MainPresenter.to.comparePeriodActualDifferencesListList
    //         .insert(0, comparePeriodActualDifferencesList);
    //   }
    //   // Insert each row of new JSON data into the original list
    //   for (List<double> comparePeriodActualPriceList
    //       in comparePeriodActualPricesListList.reversed) {
    //     MainPresenter.to.comparePeriodActualPricesListList
    //         .insert(0, comparePeriodActualPriceList);
    //   }
    //   // Insert each row of new JSON data into the original list
    //   for (List<double> matchPercentDifferencesList
    //       in matchPercentDifferencesListList.reversed) {
    //     MainPresenter.to.matchPercentDifferencesListList
    //         .insert(0, matchPercentDifferencesList);
    //   }
    //   // Insert each row of new JSON data into the original list
    //   for (List<double> matchActualDifferencesList
    //       in matchActualDifferencesListList.reversed) {
    //     MainPresenter.to.matchActualDifferencesListList
    //         .insert(0, matchActualDifferencesList);
    //   }
    //   // Insert each row of new JSON data into the original list
    //   for (List<double> matchActualPricesList
    //       in matchActualPricesListList.reversed) {
    //     MainPresenter.to.matchActualPricesListList
    //         .insert(0, matchActualPricesList);
    //   }
    // }
    try {
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
    } catch (e) {
      logger.d('4: An error occurred: $e');
    }

    MainPresenter.to.trendMatched.value = true;

    // logger.d('True${MainPresenter.to.trendMatchOutput[0]}');
    // logger.d('False${MainPresenter.to.trendMatchOutput[1]}');
    // logger.d('executionTime${MainPresenter.to.trendMatchOutput[2]}');
    // logger.d('listCandledata.length${MainPresenter.to.trendMatchOutput[3]}');
    // logger.d('selectedCount${MainPresenter.to.trendMatchOutput[4]}');
    // logger.d('candleListList${MainPresenter.to.candleListList.length}');
    // logger.d('listCandledata${MainPresenter.to.listCandledata.length}');
    // logger.d('selectedPeriodPercentDifferencesList${MainPresenter.to.selectedPeriodPercentDifferencesList.length}');
    // logger.d('selectedPeriodActualDifferencesList${MainPresenter.to.selectedPeriodActualDifferencesList.length}');
    // logger.d('selectedPeriodActualPricesList${MainPresenter.to.selectedPeriodActualPricesList.length}');
    // logger.d('comparePeriodPercentDifferencesListList${MainPresenter.to.comparePeriodPercentDifferencesListList.length}');
    // logger.d('comparePeriodActualDifferencesListList${MainPresenter.to.comparePeriodActualDifferencesListList.length}');
    // logger.d('comparePeriodActualPricesListList${MainPresenter.to.comparePeriodActualPricesListList.length}');
    // logger.d('matchPercentDifferencesListList${MainPresenter.to.matchPercentDifferencesListList.length}');
    // logger.d('matchActualDifferencesListList${MainPresenter.to.matchActualDifferencesListList.length}');
    // logger.d('matchActualPricesListList${MainPresenter.to.matchActualPricesListList.length}');
    // logger.d('matchRows${MainPresenter.to.matchRows.length}');
    // logger.d('lastCandleDataLength${MainPresenter.to.lastCandleDataLength}');
  }

  // (bool, List<double>) areDifferencesLessThanOrEqualToCertainPercent(
  //     List<double> selList, List<double> comList) {
  //   if (selList.length != comList.length) {
  //     // logger.d('${selList.length} != ${comList.length}');
  //     throw ArgumentError('Both lists must have the same length.');
  //   }

  //   for (int i = 0; i < selList.length; i++) {
  //     double difference = (comList[i] - selList[i]).abs();
  //     double percentageDifferenceAllowance = (selList[i] * 1).abs();

  //     if (difference >= percentageDifferenceAllowance) {
  //       return (false, []); // Difference is larger than or equal to certain %
  //     }
  //   }

  //   return (true, comList); // All differences are less than certain %
  // }

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

    for (int i = 0;
        i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      flspotList.add(FlSpot(
          i.toDouble(),
          MainPresenter.to.candleListList[
              MainPresenter.to.candleListList.length -
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
