import 'package:interactive_chart/interactive_chart.dart';

import '../controllers/controllers.dart';

class TrendMatch {
  countMatches(Future<List<CandleData>> futureCandleData) async {
    List<CandleData> candleData = await futureCandleData;

    List<double> selectedPeriodList = [];
    List<double> comparePeriodList = [];
    List<List<double>> comparePeriodListList = [];

    int trueCount = 0;
    int falseCount = 0;
    int selectedCount = 5;

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

      if (areDifferencesLessThanOrEqualTo30Percent(
          selectedPeriodList, comparePeriodList)) {
        trueCount += 1;
      } else {
        falseCount += 1;
      }
      comparePeriodListList.add(comparePeriodList);
      comparePeriodList.clear();
    }
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

  bool areDifferencesLessThanOrEqualTo30Percent(
      List<double> list1, List<double> list2) {
    if (list1.length != list2.length) {
      throw ArgumentError("Both lists must have the same length.");
    }

    for (int i = 0; i < list1.length; i++) {
      double difference = list1[i] - list2[i];
      double percentageDifference = (difference / list1[i]) * 100;

      if (percentageDifference.abs() > 30) {
        return false; // Difference is larger than 30%
      }
    }
    return true; // All differences are less than or equal to 30%
  }
}
