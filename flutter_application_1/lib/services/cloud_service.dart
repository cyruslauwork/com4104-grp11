import 'dart:convert';

import '../presenters/presenters.dart';
import '../services/services.dart';
import '../models/models.dart';

class CloudService {
  // Singleton implementation
  static final CloudService _instance = CloudService._();
  factory CloudService() => _instance;
  CloudService._();

  List<double> getMatchedTrendLastClosePriceAndSubsequentTrend(int index) {
    List<double> lastClosePriceAndSubsequentTrend = [];
    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

    double lastActualDifference =
        MainPresenter.to.listList[MainPresenter.to.listList.length - 1][4] /
            MainPresenter.to.listList[
                MainPresenter.to.matchRows[index] + selectedLength.toInt()][4];

    lastClosePriceAndSubsequentTrend.add(MainPresenter
        .to.selectedPeriodActualPricesList[selectedLength.toInt() - 1]);

    for (double i = selectedLength + 1; i < selectedLength * 2 + 2; i++) {
      double adjustedMatchedTrendClosePrice = MainPresenter
                  .to.listList[MainPresenter.to.matchRows[index] + i.toInt()]
              [4] // Close price of matched trend
          *
          lastActualDifference;

      lastClosePriceAndSubsequentTrend.add(adjustedMatchedTrendClosePrice);
    }

    // ignore: avoid_print
    // print(lastClosePriceAndSubsequentTrend);
    return lastClosePriceAndSubsequentTrend;
  }

  void getCsvAndPng(
      List<List<double>> lastClosePriceAndSubsequentTrends) async {
    String encodedTrends = jsonEncode(lastClosePriceAndSubsequentTrends);
    String urlEncodedTrends = Uri.encodeComponent(encodedTrends);

    Map<String, dynamic> jsonResponse = await HTTPService().fetchJson(
        'http://35.221.170.30/?func=subTrendToCsvAndPng&?sub_trend=$urlEncodedTrends');
    print('ok');
    SubsequentAnalysis().parseJson(jsonResponse);
  }
}
