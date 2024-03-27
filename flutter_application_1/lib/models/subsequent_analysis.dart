import 'dart:convert';

import '../presenters/presenters.dart';
import '../services/services.dart';
// import '../utils/utils.dart';

class SubsequentAnalysis {
  // Singleton implementation
  static final SubsequentAnalysis _instance = SubsequentAnalysis._();
  factory SubsequentAnalysis() => _instance;
  SubsequentAnalysis._();

  void init() async {
    List<List<double>> lastClosePriceAndSubsequentTrends = [];

    for (int i = 0; i < MainPresenter.to.matchRows.length; i++) {
      lastClosePriceAndSubsequentTrends
          .add(getMatchedTrendLastClosePriceAndSubsequentTrend(i));
    }
    Map<String, dynamic> parsedResponse =
        await CloudService().getCsvAndPng(lastClosePriceAndSubsequentTrends);
    // log(parsedResponse.toString());
    parseJson(parsedResponse);
  }

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
    print(lastClosePriceAndSubsequentTrend);
    return lastClosePriceAndSubsequentTrend;
  }

  void parseJson(Map<String, dynamic> parsedResponse) {
    // Get the CSV files and image data from the parsed JSON data
    Map<String, dynamic> csvFiles = parsedResponse['csv_files'];
    String img1 = csvFiles['img1'];
    String img2 = csvFiles['img2'];
    String img3 = csvFiles['img3'];
    String img4 = csvFiles['img4'];
    String img5 = csvFiles['img5'];
    String img6 = csvFiles['img6'];
    String img7 = csvFiles['img7'];

    // Convert the base64-encoded image data to bytes
    MainPresenter.to.img1Bytes.value = base64Decode(img1);
    MainPresenter.to.img2Bytes.value = base64Decode(img2);
    MainPresenter.to.img3Bytes.value = base64Decode(img3);
    MainPresenter.to.img4Bytes.value = base64Decode(img4);
    MainPresenter.to.img5Bytes.value = base64Decode(img5);
    MainPresenter.to.img6Bytes.value = base64Decode(img6);
    MainPresenter.to.img7Bytes.value = base64Decode(img7);

    MainPresenter.to.subsequentAnalysis.value = true;
  }
}
