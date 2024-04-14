import 'package:interactive_chart/interactive_chart.dart';

import 'package:flutter_application_1/presenters/presenters.dart';

import 'package:flutter_application_1/utils/utils.dart';

class TrendMatch {
  // Singleton implementation
  static final TrendMatch _instance = TrendMatch._();
  factory TrendMatch() => _instance;
  TrendMatch._();

  init({required bool init}) {
    List<CandleData> listCandledata = MainPresenter.to.listCandledata;
    // log(listCandledata.length.toString());

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
    int selectedCount = MainPresenter.to.selectedPeriod.value;

    if (selectedCount <= 1) {
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
          log('1.1: An error occurred: $e');
        }

        // Loop selected data
        try {
          for (int i = selectedCount; i > 1; i--) {
            try {
              double percentage =
                  (listCandledata[listCandledata.length - (i - 1)].close! -
                          listCandledata[listCandledata.length - i].close!) /
                      (listCandledata[listCandledata.length - i].close!);
              selectedPeriodPercentageDifferencesList.add(percentage);
            } catch (e) {
              log('1.3: An error occurred: $e');
            }
            try {
              selectedPeriodActualDifferencesList.add(
                  listCandledata[listCandledata.length - (i - 1)].close! -
                      listCandledata[listCandledata.length - i].close!);
            } catch (e) {
              log('1.4: An error occurred: $e');
            }
          }
        } catch (e) {
          log('1.2: An error occurred: $e');
        }
        try {
          for (int i = selectedCount; i > 0; i--) {
            try {
              selectedPeriodActualPricesList
                  .add(listCandledata[listCandledata.length - i].close!);
            } catch (e) {
              log('1.6: An error occurred: $e');
            }
          }
        } catch (e) {
          log('1.5: An error occurred: $e');
        }
        // log('selected data: ${selectedPeriodList.length}');
        try {
          MainPresenter.to.selectedPeriodPercentDifferencesList.value =
              selectedPeriodPercentageDifferencesList;
          MainPresenter.to.selectedPeriodActualDifferencesList.value =
              selectedPeriodActualDifferencesList;
          MainPresenter.to.selectedPeriodActualPricesList.value =
              selectedPeriodActualPricesList;
        } catch (e) {
          log('1.7: An error occurred: $e');
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
      log('1: An error occurred: $e');
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
    // log('listCandledata: ${listCandledata.length}');
    try {
      for (int l = 0;
          l <
              (init
                  ? listCandledata.length - selectedCount * 2
                  : listCandledata.length -
                      MainPresenter.to.lastCandleDataLength
                          .value); // init is false if and only if added new JSON data
          l++) {
        try {
          // Minus selectedCount to avoid counting selected data as a same match
          for (int i = 0; i < selectedCount - 1; i++) {
            try {
              double percentage = (listCandledata[l + (i + 1)].close! -
                      listCandledata[l + i].close!) /
                  (listCandledata[l + i].close!);
              comparePeriodPercentageDifferencesList.add(percentage);
            } catch (e) {
              log('2.2: An error occurred: $e');
            }
            try {
              comparePeriodActualDifferencesList.add(
                  listCandledata[l + (i + 1)].close! -
                      listCandledata[l + i].close!);
            } catch (e) {
              log('2.3: An error occurred: $e');
            }
          }
        } catch (e) {
          log('2.1: An error occurred: $e');
        }
        try {
          for (int i = 0; i < selectedCount; i++) {
            try {
              comparePeriodActualPricesList.add(listCandledata[l + i].close!);
            } catch (e) {
              log('2.5: An error occurred: $e');
            }
          }
          // log('all data: ${comparePeriodList.length}');
        } catch (e) {
          log('2.4: An error occurred: $e');
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
                log('2.8: An error occurred: $e');
              }
              try {
                for (int i = 0; i < comparisonResult.$2.length; i++) {
                  try {
                    double actual = listCandledata[l + (i + 1)].close! -
                        listCandledata[l + i].close!;
                    matchActualDifferencesList.add(actual);
                  } catch (e) {
                    log('2.9.1: An error occurred: $e');
                  }
                }
              } catch (e) {
                log('2.9: An error occurred: $e');
              }
              try {
                for (int i = 0; i < comparisonResult.$2.length + 1; i++) {
                  try {
                    matchActualPricesList.add(listCandledata[l + i].close!);
                  } catch (e) {
                    log('2.9.3: An error occurred: $e');
                  }
                }
              } catch (e) {
                log('2.9.2: An error occurred: $e');
              }
              try {
                matchActualDifferencesListList.add(matchActualDifferencesList);
                matchActualPricesListList.add(matchActualPricesList);
              } catch (e) {
                log('2.9.4: An error occurred: $e');
              }
            } else {
              falseCount += 1;
            }
          } catch (e) {
            log('2.7: An error occurred: $e');
          }
        } catch (e) {
          log('2.6: An error occurred: $e');
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
          log('2.9.4: An error occurred: $e');
        }
      }
    } catch (e) {
      log('2: An error occurred: $e');
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
      log('3: An error occurred: $e');
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
      MainPresenter.to.lastCandleDataLength.value = listCandledata.length;

      DateTime endTime = DateTime.now(); // Record the end time
      // Calculate the time difference
      Duration executionDuration = endTime.difference(startTime);
      int executionTime = executionDuration.inMilliseconds;

      MainPresenter.to.trendMatchOutput.value = [
        trueCount,
        falseCount,
        executionTime,
        listCandledata.length,
        selectedCount,
      ];
    } catch (e) {
      log('4: An error occurred: $e');
    }

    // log('True${MainPresenter.to.trendMatchOutput[0]}');
    // log('False${MainPresenter.to.trendMatchOutput[1]}');
    // log('executionTime${MainPresenter.to.trendMatchOutput[2]}');
    // log('listCandledata.length${MainPresenter.to.trendMatchOutput[3]}');
    // log('selectedCount${MainPresenter.to.trendMatchOutput[4]}');
    // log('candleListList${MainPresenter.to.candleListList.length}');
    // log('listCandledata${MainPresenter.to.listCandledata.length}');
    // log('selectedPeriodPercentDifferencesList${MainPresenter.to.selectedPeriodPercentDifferencesList.length}');
    // log('selectedPeriodActualDifferencesList${MainPresenter.to.selectedPeriodActualDifferencesList.length}');
    // log('selectedPeriodActualPricesList${MainPresenter.to.selectedPeriodActualPricesList.length}');
    // log('comparePeriodPercentDifferencesListList${MainPresenter.to.comparePeriodPercentDifferencesListList.length}');
    // log('comparePeriodActualDifferencesListList${MainPresenter.to.comparePeriodActualDifferencesListList.length}');
    // log('comparePeriodActualPricesListList${MainPresenter.to.comparePeriodActualPricesListList.length}');
    // log('matchPercentDifferencesListList${MainPresenter.to.matchPercentDifferencesListList.length}');
    // log('matchActualDifferencesListList${MainPresenter.to.matchActualDifferencesListList.length}');
    // log('matchActualPricesListList${MainPresenter.to.matchActualPricesListList.length}');
    // log('matchRows${MainPresenter.to.matchRows.length}');
    // log('lastCandleDataLength${MainPresenter.to.lastCandleDataLength}');
  }

  // (bool, List<double>) areDifferencesLessThanOrEqualToCertainPercent(
  //     List<double> selList, List<double> comList) {
  //   if (selList.length != comList.length) {
  //     // log('${selList.length} != ${comList.length}');
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
      // log('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    for (int i = 0; i < selList.length; i++) {
      double difference = comList[i] - selList[i];
      double percentageDifference = (difference / selList[i]) * 100;

      if (percentageDifference.abs() >= 100) {
        return (false, []); // Difference is larger than or equal to certain %
      }
    }

    return (true, comList); // All differences are less than certain %
  }
}
