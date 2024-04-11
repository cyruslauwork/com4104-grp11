import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/services/services.dart';

class MainPresenter extends GetxController {
  // Singleton implementation
  static MainPresenter? _instance;
  factory MainPresenter() {
    _instance ??= MainPresenter._();
    return _instance!;
  }
  MainPresenter._();

  static MainPresenter get to => Get.find();

  RxBool darkMode = true.obs;
  RxBool showAverage = true.obs;
  RxBool devMode = false.obs;

  RxInt candledownloadTime = 0.obs;
  RxList<List<dynamic>> candleListList = [[]].obs;
  RxList<CandleData> listCandleData = [
    CandleData(
        timestamp: 0000000000 * 1000,
        open: 0,
        high: 0,
        low: 0,
        close: 0,
        volume: 0)
  ].obs;

  RxInt listingDownloadTime = 0.obs;
  RxList<List<dynamic>> symbolAndNameListList = [[]].obs;
  RxList<SymbolAndName> listSymbolAndName =
      [const SymbolAndName(symbol: '', name: '')].obs;

  RxInt lastClosePriceAndSubsequentTrendsExeTime = 0.obs;
  RxInt cloudSubsequentAnalysisTime = 0.obs;

  RxInt selectedPeriod = 5.obs;
  RxList<double> selectedPeriodPercentDifferencesList =
      [0.0].obs; // The root selected period here
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

  Rx<DateTime> lastJsonEndDate = DateTime(2023).obs;
  List<Map<String, dynamic>> lastJson = [];
  RxInt lastCandleDataLength = 0.obs;

  RxBool subsequentAnalysis = false.obs;
  Rx<Uint8List> img1Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img2Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img3Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img4Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img5Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img6Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img7Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  RxString subsequentAnalysisErr = ''.obs;

  RxBool isEn = true.obs;

  RxList<SymbolAndName> symbolAndNameList =
      [const SymbolAndName(symbol: '', name: '')].obs;
  RxBool searched = false.obs;

  void reload() {
    Get.delete<MainPresenter>();
    Get.put(MainPresenter());
    super.onInit();
  }

  Future<List<CandleData>> futureListCandleData({String? stockSymbol}) async {
    // PrefsService.to.prefs
    //     .setString(SharedPreferencesConstant.stockSymbol, 'SPY');
    stockSymbol ??= PrefsService.to.prefs
            .getString(SharedPreferencesConstant.stockSymbol) ??
        'SPY';
    // print(stockSymbol);
    Future<List<CandleData>> futureListCandleData = CandleAdapter()
        .listListToCandles(
            Candle().checkAPIProvider(init: true, stockSymbol: stockSymbol));
    var abc = await futureListCandleData;
    print(abc.length);
    await TrendMatch().countMatches(futureListCandleData, init: true);
    // SubsequentAnalysis().init();
    return futureListCandleData;
  }

  void showSnackBar(Function showSnackBar, Func func) {
    if (func == Func.devMode) {
      showSnackBar('Developer mode is on');
    } else {
      throw ArgumentError('Error: Failed to get function name.');
    }
  }
}
