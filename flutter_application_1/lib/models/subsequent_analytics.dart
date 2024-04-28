import 'dart:convert';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
// import 'package:flutter_application_1/utils/utils.dart';

class SubsequentAnalytics {
  // Singleton implementation
  static final SubsequentAnalytics _instance = SubsequentAnalytics._();
  factory SubsequentAnalytics() => _instance;
  SubsequentAnalytics._();

  void init() async {
    MainPresenter.to.hasSubsequentAnalytics.value = false;

    List<List<double>> lastClosePriceAndSubsequentTrends = [];

    DateTime exeStartTime = DateTime.now(); // Record the download start time
    for (int i = 0; i < MainPresenter.to.matchRows.length; i++) {
      lastClosePriceAndSubsequentTrends
          .add(getMatchedTrendLastClosePriceAndSubsequentTrend(i));
    }
    DateTime exeEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration exeDuration = exeEndTime.difference(exeStartTime);
    int exeTime = exeDuration.inMilliseconds;
    MainPresenter.to.lastClosePriceAndSubsequentTrendsExeTime.value = exeTime;

    if (lastClosePriceAndSubsequentTrends.length >= 4) {
      exeStartTime = DateTime.now(); // Record the download start time
      // log(lastClosePriceAndSubsequentTrends.toString());
      CloudService()
          .getCsvAndPng(lastClosePriceAndSubsequentTrends)
          .then((parsedResponse) {
        // log(parsedResponse.toString());
        exeEndTime = DateTime.now(); // Record the download end time
        // Calculate the time difference
        exeDuration = exeEndTime.difference(exeStartTime);
        exeTime = exeDuration.inMilliseconds;
        MainPresenter.to.cloudSubsequentAnalyticsTime.value = exeTime;
        try {
          Map<String, dynamic> csvPngFiles = parsedResponse['csv_png_files'];
          MainPresenter.to.subsequentAnalyticsErr.value = '';
          parseJson(csvPngFiles);
        } catch (e) {
          String err = parsedResponse['error'];
          MainPresenter.to.subsequentAnalyticsErr.value = err;
        }
        MainPresenter.to.hasSubsequentAnalytics.value = true;
      }).catchError((error) {
        // Handle any errors during the asynchronous operation
        // ...
      });
    } else {
      MainPresenter.to.subsequentAnalyticsErr.value =
          'The number of subsequent trends must be equal to or greater than 4.';
      MainPresenter.to.hasSubsequentAnalytics.value = true;
    }
  }

  List<double> getMatchedTrendLastClosePriceAndSubsequentTrend(int index) {
    List<double> lastClosePriceAndSubsequentTrend = [];
    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

    double lastActualDifference = MainPresenter
            .to.candleListList[MainPresenter.to.candleListList.length - 1][4] /
        MainPresenter.to.candleListList[
            MainPresenter.to.matchRows[index] + selectedLength.toInt()][4];

    lastClosePriceAndSubsequentTrend.add(MainPresenter
        .to.selectedPeriodActualPricesList[selectedLength.toInt() - 1]);

    for (double i = selectedLength + 1; i < selectedLength * 2 + 2; i++) {
      double adjustedMatchedTrendClosePrice = MainPresenter.to
                  .candleListList[MainPresenter.to.matchRows[index] + i.toInt()]
              [4] // Close price of matched trend
          *
          lastActualDifference;

      lastClosePriceAndSubsequentTrend.add(adjustedMatchedTrendClosePrice);
    }

    // ignore: avoid_print
    // print(lastClosePriceAndSubsequentTrend);
    return lastClosePriceAndSubsequentTrend;
  }

  void parseJson(Map<String, dynamic> csvPngFiles) {
    // Get the data from the parsed JSON data
    String img1 = csvPngFiles['img1'];
    String img2 = csvPngFiles['img2'];
    String img3 = csvPngFiles['img3'];
    String img4 = csvPngFiles['img4'];
    String img5 = csvPngFiles['img5'];
    String img6 = csvPngFiles['img6'];
    String img7 = csvPngFiles['img7'];

    // Convert the base64-encoded image data to bytes
    MainPresenter.to.img1Bytes.value = base64Decode(img1);
    MainPresenter.to.img2Bytes.value = base64Decode(img2);
    MainPresenter.to.img3Bytes.value = base64Decode(img3);
    MainPresenter.to.img4Bytes.value = base64Decode(img4);
    MainPresenter.to.img5Bytes.value = base64Decode(img5);
    MainPresenter.to.img6Bytes.value = base64Decode(img6);
    MainPresenter.to.img7Bytes.value = base64Decode(img7);

    MainPresenter.to.numOfClusters.value = csvPngFiles['num_of_clusters'];

    MainPresenter.to.maxSilhouetteScore.value =
        csvPngFiles['max_silhouette_score'];
  }
}
