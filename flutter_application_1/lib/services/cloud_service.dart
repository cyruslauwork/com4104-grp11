import '../presenters/presenters.dart';

getMatchedTrendLastClosePriceAndSubsequentTrend(int index) {
  List<double> matchedTrend = [];
  double selectedLength =
      MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

  double lastActualDifference =
      MainPresenter.to.listList[MainPresenter.to.listList.length - 1][4] /
          MainPresenter.to.listList[
              MainPresenter.to.matchRows[index] + selectedLength.toInt()][4];

  matchedTrend.add(MainPresenter
      .to.selectedPeriodActualPricesList[selectedLength.toInt() - 1]);

  for (double i = selectedLength + 1; i < selectedLength * 2 + 2; i++) {
    double adjustedMatchedTrendClosePrice =
        MainPresenter.to.listList[MainPresenter.to.matchRows[index] + i.toInt()]
                [4] // Close price of matched trend
            *
            lastActualDifference;

    matchedTrend.add(adjustedMatchedTrendClosePrice);
  }

  // ignore: avoid_print
  print(matchedTrend);
}
