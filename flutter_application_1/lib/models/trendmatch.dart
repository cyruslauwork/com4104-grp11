import 'package:interactive_chart/interactive_chart.dart';

import '../controllers/controllers.dart';
// import 'models.dart';

class TrendMatch {
  countMatches(Future<List<CandleData>> futureCandleData,
      {required bool init}) async {
    List<CandleData> candleData = await futureCandleData;

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
    int selectedCount =
        GlobalController.to.selectedPeriodPercentDifferencesList.length;

    if (selectedCount <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    // init is false if and only if added new JSON data
    if (init) {
      GlobalController.to.matchRows.removeAt(0);
      GlobalController.to.matchPercentDifferencesListList.removeAt(0);
      GlobalController.to.matchActualDifferencesListList.removeAt(0);
      GlobalController.to.matchActualPricesListList.removeAt(0);

      // Loop selected data
      for (int i = selectedCount; i > 1; i--) {
        double percentage = (candleData[candleData.length - (i - 1)].close! -
                candleData[candleData.length - i].close!) /
            (candleData[candleData.length - i].close!);
        selectedPeriodPercentageDifferencesList.add(percentage);

        selectedPeriodActualDifferencesList.add(
            candleData[candleData.length - (i - 1)].close! -
                candleData[candleData.length - i].close!);
      }
      for (int i = selectedCount; i > 0; i--) {
        selectedPeriodActualPricesList
            .add(candleData[candleData.length - i].close!);
      }
      // print('selected data: ${selectedPeriodList.length}');
      GlobalController.to.selectedPeriodPercentDifferencesList.value =
          selectedPeriodPercentageDifferencesList;
      GlobalController.to.selectedPeriodActualDifferencesList.value =
          selectedPeriodActualDifferencesList;
      GlobalController.to.selectedPeriodActualPricesList.value =
          selectedPeriodActualPricesList;
      // difference between start and user selected date --> l
      // user selected range
      // --> 整daterange field
      // for (int i = 0; i < selectedCount - 1; i++) {
      //   double percentage =
      //       (candleData[l + (i + 1)].close! - candleData[l + i].close!) /
      //           (candleData[l + i].close!);
      //   selectedPeriodList.add(percentage);
      // }
    } else {
      selectedPeriodPercentageDifferencesList =
          GlobalController.to.selectedPeriodPercentDifferencesList;
      selectedPeriodActualDifferencesList =
          GlobalController.to.selectedPeriodActualDifferencesList;
      selectedPeriodActualPricesList =
          GlobalController.to.selectedPeriodActualPricesList;
    }

    // Loop all data
    // print('candleData: ${candleData.length}');
    for (int l = 0;
        l <
            (init
                ? candleData.length - selectedCount
                : candleData.length -
                    GlobalController.to.lastCandleDataLength
                        .value); // init is false if and only if added new JSON data
        l++) {
      // Minus selectedCount to avoid counting selected data as a same match
      for (int i = 0; i < selectedCount - 1; i++) {
        double percentage =
            (candleData[l + (i + 1)].close! - candleData[l + i].close!) /
                (candleData[l + i].close!);
        comparePeriodPercentageDifferencesList.add(percentage);

        comparePeriodActualDifferencesList
            .add(candleData[l + (i + 1)].close! - candleData[l + i].close!);

        comparePeriodActualPricesList.add(candleData[l + i].close!);
      }
      // print('all data: ${comparePeriodList.length}');

      (
        bool,
        List<double>
      ) comparisonResult = areDifferencesLessThanOrEqualToCertainPercent(
          selectedPeriodPercentageDifferencesList,
          comparePeriodPercentageDifferencesList); // Record data type in Dart is equivalent to Tuple in Java and Python
      if (comparisonResult.$1) {
        trueCount += 1;

        // matchPercentDifferencesList = comparePeriodPercentageDifferencesList;
        GlobalController.to.matchRows.add(l);
        matchPercentDifferencesListList.add(comparisonResult.$2);
        for (int i = 0; i < comparisonResult.$2.length; i++) {
          double actual =
              candleData[l + (i + 1)].close! - candleData[l + i].close!;
          matchActualDifferencesList.add(actual);
          matchActualPricesList.add(candleData[l + i].close!);
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

    // init is false if and only if added new JSON data
    if (init) {
      GlobalController.to.comparePeriodPercentDifferencesListList.value =
          comparePeriodPercentageDifferencesListList;
      GlobalController.to.comparePeriodActualDifferencesListList.value =
          comparePeriodActualDifferencesListList;
      GlobalController.to.comparePeriodActualPricesListList.value =
          comparePeriodActualPricesListList;

      GlobalController.to.matchPercentDifferencesListList.value =
          matchPercentDifferencesListList;
      GlobalController.to.matchActualDifferencesListList.value =
          matchActualDifferencesListList;
      GlobalController.to.matchActualPricesListList.value =
          matchActualPricesListList;
    } else {
      // Insert each row of new JSON data into the original list
      for (List<double> comparePeriodPercentageList
          in comparePeriodPercentageDifferencesListList.reversed) {
        GlobalController.to.comparePeriodPercentDifferencesListList
            .insert(0, comparePeriodPercentageList);
      }
      // Insert each row of new JSON data into the original list
      for (List<double> comparePeriodActualDifferencesList
          in comparePeriodActualDifferencesListList.reversed) {
        GlobalController.to.comparePeriodActualDifferencesListList
            .insert(0, comparePeriodActualDifferencesList);
      }
      // Insert each row of new JSON data into the original list
      for (List<double> comparePeriodActualPriceList
          in comparePeriodActualPricesListList.reversed) {
        GlobalController.to.comparePeriodActualPricesListList
            .insert(0, comparePeriodActualPriceList);
      }
      // Insert each row of new JSON data into the original list
      for (List<double> matchPercentDifferencesList
          in matchPercentDifferencesListList.reversed) {
        GlobalController.to.matchPercentDifferencesListList
            .insert(0, matchPercentDifferencesList);
      }
      // Insert each row of new JSON data into the original list
      for (List<double> matchActualDifferencesList
          in matchActualDifferencesListList.reversed) {
        GlobalController.to.matchActualDifferencesListList
            .insert(0, matchActualDifferencesList);
      }
      // Insert each row of new JSON data into the original list
      for (List<double> matchActualPricesList
          in matchActualPricesListList.reversed) {
        GlobalController.to.matchActualPricesListList
            .insert(0, matchActualPricesList);
      }
    }
    GlobalController.to.lastCandleDataLength.value = candleData.length;

    DateTime endTime = DateTime.now(); // Record the end time
    // Calculate the time difference
    Duration executionDuration = endTime.difference(startTime);
    int executionTime = executionDuration.inMilliseconds;

    GlobalController.to.trendMatchOutput.value = [
      trueCount + GlobalController.to.trendMatchOutput[0],
      falseCount + GlobalController.to.trendMatchOutput[1],
      executionTime,
      candleData.length,
      selectedCount,
    ];
  }

  (bool, List<double>) areDifferencesLessThanOrEqualToCertainPercent(
      List<double> selList, List<double> comList) {
    if (selList.length != comList.length) {
      // print('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    for (int i = 0; i < selList.length; i++) {
      double difference = selList[i] - comList[i];
      double percentageDifference = (difference / selList[i]) * 100;

      if (percentageDifference.abs() >= 100) {
        return (false, []); // Difference is larger than or equal to certain %
      }
    }
    return (true, comList); // All differences are less than certain %
  }
}
