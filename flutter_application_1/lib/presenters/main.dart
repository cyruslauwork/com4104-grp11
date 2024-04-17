import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/views/views.dart';

// import 'package:flutter_application_1/utils/utils.dart';

class MainPresenter extends GetxController {
  // Singleton implementation
  static MainPresenter? _instance;
  factory MainPresenter() {
    _instance ??= MainPresenter._();
    return _instance!;
  }
  MainPresenter._();

  static MainPresenter get to => Get.find();

  /* Preference */
  RxBool darkMode =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.darkMode) ??
              true)
          .obs;
  ValueNotifier<bool> devMode = ValueNotifier<bool>(false);
  ValueNotifier<bool> isEn = ValueNotifier<bool>(
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.isEn) ?? true));

  /* Candlestick-related */
  RxInt candledownloadTime = 0.obs;
  RxList<List<dynamic>> candleListList = [[]].obs;
  late Rx<Future<List<CandleData>>> futureListCandledata = init().obs;
  RxList<CandleData> listCandledata = [
    CandleData(
        timestamp: 0000000000 * 1000,
        open: 0,
        high: 0,
        low: 0,
        close: 0,
        volume: 0),
    // CandleData(
    //     timestamp: 1555939800 * 1000,
    //     open: 51.80,
    //     high: 53.94,
    //     low: 50.50,
    //     close: 52.55,
    //     volume: 60735500),
    // CandleData(
    //     timestamp: 1556026200 * 1000,
    //     open: 43.80,
    //     high: 53.94,
    //     low: 42.50,
    //     close: 52.55,
    //     volume: 60735500),
    // CandleData(
    //     timestamp: 1556112600 * 1000,
    //     open: 73.80,
    //     high: 83.94,
    //     low: 52.50,
    //     close: 72.55,
    //     volume: 60735500),
  ].obs;
  ValueNotifier<bool> showAverage = ValueNotifier<bool>(true);

  /* Listing */
  RxInt listingDownloadTime = 0.obs;
  RxList<SymbolAndName> listSymbolAndName =
      [const SymbolAndName(symbol: '', name: '')].obs;

  /* Search */
  ValueNotifier<int> searchCount = ValueNotifier<int>(0);

  /* Chat */
  RxList<String> messages = [
    "Hi! I'm your dedicated News AI, here to assist you in analyzing news related to your preferred financial instruments! ^_^"
  ].obs;
  RxBool isWaitingForReply = false.obs;
  RxInt aiResponseTime = 0.obs;
  RxDouble thisScrollExtent = 0.0.obs;

  /* Trend match */
  RxInt selectedPeriod = 5.obs; // The root selected period here
  RxList<double> selectedPeriodPercentDifferencesList = [0.0].obs;
  RxList<double> selectedPeriodActualDifferencesList = [0.0].obs;
  RxList<double> selectedPeriodActualPricesList = [0.0].obs;
  RxList<List<double>> comparePeriodPercentDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> comparePeriodActualDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> comparePeriodActualPricesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchPercentDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchActualDifferencesListList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchActualPricesListList = [
    [0.0]
  ].obs;
  RxList<int> trendMatchOutput = [0, 0, 0, 0, 0].obs;
  RxList<int> matchRows = [0].obs;
  Rx<bool> trendMatched = false.obs;

  /* Subsequent analysis */
  RxInt lastClosePriceAndSubsequentTrendsExeTime = 0.obs;
  RxInt cloudSubsequentAnalysisTime = 0.obs;
  RxBool hasSubsequentAnalysis = false.obs;
  Rx<Uint8List> img1Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img2Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img3Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img4Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img5Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img6Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img7Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  RxString subsequentAnalysisErr = ''.obs;

  Rx<DateTime> lastJsonEndDate = DateTime(2023).obs;
  List<Map<String, dynamic>> lastJson = [];
  RxInt lastCandleDataLength = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    showAverage.addListener(() {
      // Perform actions based on the new value of showAverage
      if (showAverage.value) {
        // Show the average
        Candle().computeTrendLines();
      } else {
        // Hide the average
        Candle().removeTrendLines();
      }
    });
    devMode.addListener(() {
      if (devMode.value) {
        Get.snackbar(
            'System Info',
            colorText: AppColor.whiteColor,
            backgroundColor: AppColor.greyColor,
            icon: const Icon(Icons.settings),
            'Developer mode is on');
      }
    });
    isEn.addListener(() {
      if (isEn.value) {
        LangService.to.changeLanguage(Lang.en);
      } else {
        LangService.to.changeLanguage(Lang.zh);
      }
    });
    searchCount.addListener(() {
      futureListCandledata.value = init();
    });
  }

  void reload() {
    Get.delete<MainPresenter>();
    Get.put(MainPresenter());
    super.onInit();
  }

  Future<List<CandleData>> init() async {
    await Candle().init();
    if (showAverage.value) {
      Candle().computeTrendLines();
    }
    TrendMatch().init(init: true);
    SubsequentAnalysis().init();
    return listCandledata;
  }

  /* Route */
  void route(String path) {
    Get.toNamed(path);
  }

  void back() {
    Get.back();
  }

  /* UI Logic*/
  List<Widget> showListingRelatedIcons() {
    Listing().init();
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          MainPresenter.to.route(RouteName.searchView.path);
        },
      ),
      IconButton(
        icon: const Icon(Icons.contact_support),
        onPressed: () {
          MainPresenter.to.route(RouteName.chatView.path);
        },
      ),
    ];
  }

  Widget showTm() {
    return Obx(() {
      if (trendMatched.value) {
        return TrendMatchView().showAdjustedLineChart();
      } else {
        return TrendMatchView().showCircularProgressIndicator();
      }
    });
  }

  Widget showSa() {
    return Obx(() {
      if (hasSubsequentAnalysis.value) {
        if (subsequentAnalysisErr.value == '') {
          return SubsequentAnalysisView().showSaChart();
        } else {
          return SubsequentAnalysisView().showError();
        }
      } else {
        return SubsequentAnalysisView().showCircularProgressIndicator();
      }
    });
  }
}
