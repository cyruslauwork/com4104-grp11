import 'dart:convert';
import 'dart:math';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/services/services.dart';
// import 'package:market_ai/utils/utils.dart';

class SubsequentAnalytics {
  // Singleton implementation
  static final SubsequentAnalytics _instance = SubsequentAnalytics._();
  factory SubsequentAnalytics() => _instance;
  SubsequentAnalytics._();

  void init() async {
    MainPresenter.to.subsequentAnalyticsNotifier.value = false;
    MainPresenter.to.saCount++;
    int saCount = MainPresenter.to.saCount.value;

    List<List<double>> lastClosePriceAndSubsequentTrends = [];

    DateTime exeStartTime = DateTime.now(); // Record the download start time
    for (int i = 0; i < MainPresenter.to.matchRows.length; i++) {
      lastClosePriceAndSubsequentTrends
          .add(getMatchedTrendLastClosePriceAndSubsequentTrend(i));
    }
    double minValueOfAllTrends = double.infinity;
    double maxValueOfAllTrends = double.negativeInfinity;
    List<List<dynamic>> candleListList = MainPresenter.to.candleListList;
    if (lastClosePriceAndSubsequentTrends.isNotEmpty) {
      for (List<double> sublist in lastClosePriceAndSubsequentTrends) {
        for (double value in sublist) {
          minValueOfAllTrends = min(minValueOfAllTrends, value);
          maxValueOfAllTrends = max(maxValueOfAllTrends, value);
        }
      }
    }
    int selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length;
    int candleListListLength = MainPresenter.to.candleListList.length;
    // Selected trend
    for (int i = 0; i < selectedLength; i++) {
      double value =
          candleListList[candleListListLength - selectedLength.toInt() + i - 1]
              [4];
      minValueOfAllTrends = min(minValueOfAllTrends, value);
      maxValueOfAllTrends = max(maxValueOfAllTrends, value);
    }
    double lastSelectedClosePrice = candleListList[candleListListLength - 1][4];
    List<int> matchRows = MainPresenter.to.matchRows;
    // Adjusted trends
    for (int index in matchRows) {
      double lastActualDifference =
          lastSelectedClosePrice / candleListList[index + selectedLength][4];
      for (int i = 0; i < selectedLength + 1; i++) {
        double adjustedMatchedTrendClosePrice =
            candleListList[index + i.toInt()][4] // Close price of matched trend
                *
                lastActualDifference;
        minValueOfAllTrends =
            min(minValueOfAllTrends, adjustedMatchedTrendClosePrice);
        maxValueOfAllTrends =
            max(maxValueOfAllTrends, adjustedMatchedTrendClosePrice);
      }
    }

    DateTime exeEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration exeDuration = exeEndTime.difference(exeStartTime);
    int exeTime = exeDuration.inMilliseconds;
    MainPresenter.to.lastClosePriceAndSubsequentTrendsExeTime.value = exeTime;

    if (lastClosePriceAndSubsequentTrends.length >= 4) {
      exeStartTime = DateTime.now(); // Record the download start time
      CloudService()
          .getCsvAndPng(
        lastClosePriceAndSubsequentTrends: lastClosePriceAndSubsequentTrends,
        minValueOfAllTrends: minValueOfAllTrends,
        maxValueOfAllTrends: maxValueOfAllTrends,
      )
          .then((parsedResponse) {
        // Check if multiple SAs are queued
        if (MainPresenter.to.saCount.value == saCount) {
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
        } else {
          return;
        }
      }).catchError((error) {
        // Handle any errors during the asynchronous operation
        MainPresenter.to.subsequentAnalyticsErr.value =
            'An unexpected error occurred in getCsvAndPng()';
      });
    } else {
      MainPresenter.to.subsequentAnalyticsErr.value =
          'The number of subsequent trends must be equal to or greater than 4.';
    }
    MainPresenter.to.subsequentAnalyticsNotifier.value = true;
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
        .to.selectedPeriodActualPricesList[selectedLength.toInt()]);

    for (double i = selectedLength + 1; i < selectedLength * 2 + 2; i++) {
      double adjustedMatchedTrendClosePrice = MainPresenter.to
                  .candleListList[MainPresenter.to.matchRows[index] + i.toInt()]
              [4] // Close price of matched trend
          *
          lastActualDifference;

      lastClosePriceAndSubsequentTrend.add(adjustedMatchedTrendClosePrice);
    }

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
    String img8 = csvPngFiles['img8'];
    String img9 = csvPngFiles['img9'];
    String img10 = csvPngFiles['img10'];

    // Convert the base64-encoded image data to bytes
    MainPresenter.to.img1Bytes.value = base64Decode(img1);
    MainPresenter.to.img2Bytes.value = base64Decode(img2);
    MainPresenter.to.img3Bytes.value = base64Decode(img3);
    MainPresenter.to.img4Bytes.value = base64Decode(img4);
    MainPresenter.to.img5Bytes.value = base64Decode(img5);
    MainPresenter.to.img6Bytes.value = base64Decode(img6);
    MainPresenter.to.img7Bytes.value = base64Decode(img7);
    MainPresenter.to.img8Bytes.value = base64Decode(img8);
    MainPresenter.to.img9Bytes.value = base64Decode(img9);
    MainPresenter.to.img10Bytes.value = base64Decode(img10);

    MainPresenter.to.numOfClusters.value = csvPngFiles['num_of_clusters'];

    MainPresenter.to.maxSilhouetteScore.value =
        double.parse(csvPngFiles['max_silhouette_score']).toStringAsFixed(3);
  }
}
