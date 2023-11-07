import 'package:interactive_chart/interactive_chart.dart';

import '../controllers/controllers.dart';

class TrendMatch {
  countMatches(Future<List<CandleData>> futureCandleData) async {
    List<CandleData> candleData = await futureCandleData;

    List<double> selectedPeriodList = [];
    List<double> comparePeriodList = [];
    List<List<double>> comparePeriodListList = [];
    List<List<double>> matchListList = [];

    int trueCount = 0;
    int falseCount = 0;
    int selectedCount = 5;

    if (selectedCount <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    // Loop selected data
    for (int i = selectedCount - 1; i > 0; i--) {
      double percentage = (candleData[candleData.length - (i + 1)].close! -
              candleData[candleData.length - i].close!) /
          (candleData[candleData.length - i].close!);
      selectedPeriodList.add(percentage);
    }
    // logger.d(selectedPeriodList.length);
    GlobalController.to.selectedPeriodList.value = selectedPeriodList;

    // Loop all data
    for (int l = 0; l < candleData.length - selectedCount; l++) {
      // Minus selectedCount to avoid counting selected data as a same match
      for (int i = 0; i < selectedCount - 1; i++) {
        double percentage =
            (candleData[l + (i + 1)].close! - candleData[l + i].close!) /
                (candleData[l + i].close!);
        comparePeriodList.add(percentage);
      }
      // logger.d(comparePeriodList.length);

      (
        bool,
        List<double>
      ) comparisonResult = areDifferencesLessThanOrEqualTo30Percent(
          selectedPeriodList,
          comparePeriodList); // Record data type in Dart is equivalent to Tuple in Java and Python
      if (comparisonResult.$1) {
        trueCount += 1;
        matchListList.add(comparisonResult.$2);
      } else {
        falseCount += 1;
      }
      comparePeriodListList.add(comparePeriodList);
      comparePeriodList = [];
    }
    GlobalController.to.matchListList.value = matchListList;
    GlobalController.to.comparePeriodList.value = comparePeriodListList;

    DateTime endTime = DateTime.now(); // Record the end time
    // Calculate the time difference
    Duration executionDuration = endTime.difference(startTime);
    int executionTime = executionDuration.inMilliseconds;

    GlobalController.to.trendMatchOutput.value = [
      trueCount,
      falseCount,
      executionTime,
      candleData.length,
      selectedCount,
    ];
  }

  (bool, List<double>) areDifferencesLessThanOrEqualTo30Percent(
      List<double> selList, List<double> comList) {
    if (selList.length != comList.length) {
      throw ArgumentError('Both lists must have the same length.');
    }

    for (int i = 0; i < selList.length; i++) {
      double difference = selList[i] - comList[i];
      double percentageDifference = (difference / selList[i]) * 100;

      if (percentageDifference.abs() > 30) {
        return (false, []); // Difference is larger than 30%
      }
    }
    return (true, comList); // All differences are less than or equal to 30%
  }
}
