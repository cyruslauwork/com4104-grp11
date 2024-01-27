import '../../controllers/controllers.dart';

getMatchedTrend(int index) {
  List<double> matchedTrend = [];

  double lastSelectedClosePrice =
      GlobalController.to.listList[GlobalController.to.listList.length - 1][4];

  double lastActualDifference = GlobalController
          .to.listList[GlobalController.to.listList.length - 1][4] /
      GlobalController.to.listList[GlobalController.to.matchRows[index] +
          GlobalController.to.selectedPeriodActualDifferencesList.length][4];

  for (double i =
          GlobalController.to.selectedPeriodPercentDifferencesList.length + 1;
      i <
          GlobalController.to.selectedPeriodPercentDifferencesList.length * 2 +
              2;
      i++) {
    double adjustedMatchedTrendClosePrice = GlobalController
                .to.listList[GlobalController.to.matchRows[index] + i.toInt()]
            [4] // Close price of matched trend
        *
        lastActualDifference;

    matchedTrend.add(adjustedMatchedTrendClosePrice);
  }

  // print(matchedTrend);
}
