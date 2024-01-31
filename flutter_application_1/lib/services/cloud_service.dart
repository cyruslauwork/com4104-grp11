import '../presenters/presenters.dart';

getMatchedTrend(int index) {
  List<double> matchedTrend = [];

  double lastSelectedClosePrice =
      MainPresenter.to.listList[MainPresenter.to.listList.length - 1][4];

  double lastActualDifference =
      MainPresenter.to.listList[MainPresenter.to.listList.length - 1][4] /
          MainPresenter.to.listList[MainPresenter.to.matchRows[index] +
              MainPresenter.to.selectedPeriodActualDifferencesList.length][4];

  for (double i =
          MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
      i < MainPresenter.to.selectedPeriodPercentDifferencesList.length * 2 + 2;
      i++) {
    double adjustedMatchedTrendClosePrice =
        MainPresenter.to.listList[MainPresenter.to.matchRows[index] + i.toInt()]
                [4] // Close price of matched trend
            *
            lastActualDifference;

    matchedTrend.add(adjustedMatchedTrendClosePrice);
  }

  // print(matchedTrend);
}
