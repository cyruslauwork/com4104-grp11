import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import '../models/models.dart';
import '../services/services.dart';

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

  RxInt downloadTime = 0.obs;
  RxList<List<dynamic>> listList = [[]].obs;
  RxList<CandleData> listCandleData = [
    CandleData(timestamp: 0000000000 * 1000, open: 0, close: 0, volume: 0)
  ].obs;

  RxList<double> selectedPeriodPercentDifferencesList =
      [0.0, 0.0, 0.0, 0.0, 0.0].obs; // The root selected period here
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

  RxInt elapsedTime = 0.obs;
  Rx<DateTime> lastJsonEndDate = DateTime(2023).obs;
  List<Map<String, dynamic>> lastJson = [];
  RxInt lastCandleDataLength = 0.obs;

  void reload() {
    Get.delete<MainPresenter>();
    Get.put(MainPresenter());
    super.onInit();
  }

  Future<List<CandleData>> get futureListCandleData async {
    Future<List<CandleData>> futureListCandleData = CandleAdapter()
        .listListToCandles(Candle().checkAPIProvider(init: true));
    TrendMatch().countMatches(futureListCandleData, init: true);
    return futureListCandleData;
  }

  void addJson(Function showSnackBar) {
    if (FlavorService.to.apiProvider == APIProvider.polygon) {
      TrendMatch().countMatches(
          CandleAdapter()
              .listListToCandles(Candle().checkAPIProvider(init: false)),
          init: false);
      MainPresenter.to.elapsedTime.value = 0;
    } else if (FlavorService.to.apiProvider == APIProvider.yahoofinance) {
      showSnackBar('You can only add JSON data if you\'re using JSON data.');
    } else {
      throw ArgumentError('Failed to check API provider.');
    }
  }
}