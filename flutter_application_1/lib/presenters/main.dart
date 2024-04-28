import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';

import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/views/views.dart';

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
              false)
          .obs;
  bool isDarkModeInit = false;
  RxBool devMode = false.obs;
  ValueNotifier<bool> devModeNotifier = ValueNotifier<bool>(false);
  bool isDevModeListenerAdded = false;
  ValueNotifier<bool> isEnNotifier = ValueNotifier<bool>(
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.isEn) ?? true));
  bool isEnListenerAdded = false;
  RxBool alwaysShowAnalytics = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowAnalytics) ??
          false)
      .obs;

  /* Candlestick-related */
  RxString financialInstrumentSymbol = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.financialInstrumentSymbol) ??
          'SPY')
      .obs;
  RxString financialInstrumentName = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.financialInstrumentName) ??
          'SPDR S&P 500 ETF Trust')
      .obs;
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
  ValueNotifier<bool> showAverageNotifier = ValueNotifier<bool>(true);
  bool isShowAverageListenerAdded = false;
  late RxString marketDataProviderMsg = Rx('mkt_data'.tr)().obs;
  RxBool isMarketDataProviderErr = false.obs;

  /* Listings */
  RxInt listingsDownloadTime = 0.obs;
  RxList<SymbolAndName> listSymbolAndName =
      [const SymbolAndName(symbol: '', name: '')].obs;
  RxString listingErr = ''.obs;
  RxBool isListingInit = false.obs;
  late RxString listingsProviderMsg = Rx('listings'.tr)().obs;
  RxBool isListingsProviderErr = false.obs;

  /* Search */
  ValueNotifier<int> searchCountNotifier = ValueNotifier<int>(0);
  bool isSearchCountListenerAdded = false;

  /* Chat */
  RxList<String> messages = (PrefsService.to.prefs
              .getStringList(SharedPreferencesConstant.messages) ??
          [
            "Hi! I'm your dedicated News AI, here to assist you in analyzing news related to your preferred stocks or ETFs! ^_^"
          ])
      .obs;
  RxBool isWaitingForReply = false.obs;
  RxInt aiResponseTime = 0.obs;
  RxBool firstQuestion = true.obs;

  /* Trend match */
  RxInt range =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.range) ?? 5).obs;
  RxInt tolerance =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.tolerance) ?? 100)
          .obs;
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
  RxBool trendMatched = false.obs;
  RxBool showAnalytics = false.obs;
  ValueNotifier<bool> showAnalyticsNotifier = ValueNotifier<bool>(false);
  bool isShowAnalyticsNotifierAdded = false;
  late RxDouble candleChartHeight = (showAnalytics.value ? 50.h : 100.h).obs;
  ValueNotifier<bool> chartExpandNotifier = ValueNotifier<bool>(true);
  bool isChartExpandNotifierAdded = false;
  Rx<IconData> expandOrShrinkIcon = Icons.vertical_align_center_rounded.obs;

  /* Subsequent analytics */
  RxInt lastClosePriceAndSubsequentTrendsExeTime = 0.obs;
  RxInt cloudSubsequentAnalyticsTime = 0.obs;
  RxBool hasSubsequentAnalytics = false.obs;
  Rx<Uint8List> img1Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img2Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img3Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img4Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img5Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img6Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img7Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  RxString subsequentAnalyticsErr = ''.obs;
  RxInt numOfClusters = 0.obs;
  RxString maxSilhouetteScore = ''.obs;

  Rx<DateTime> lastJsonEndDate = DateTime(2023).obs;
  List<Map<String, dynamic>> lastJson = [];
  RxInt lastCandledataLength = 0.obs;

  // A 2nd initialization will be triggered when starting the app
  @override
  void onInit() {
    // PrefsService.to.prefs
    //     .setString(SharedPreferencesConstant.financialInstrumentSymbol, 'SPY');
    // PrefsService.to.prefs.setString(
    //     SharedPreferencesConstant.financialInstrumentName,
    //     'SPDR S&P 500 ETF Trust');
    // PrefsService.to.prefs.setInt(SharedPreferencesConstant.range, 5);
    // PrefsService.to.prefs.setInt(SharedPreferencesConstant.tolerance, 100);

    super.onInit();
    if (!isDarkModeInit) {
      if (darkMode.value) {
        AppColor.primaryTextColor = Colors.white;
      } else {
        AppColor.primaryTextColor = Colors.black;
      }
      isDarkModeInit = true;
    }

    if (!isShowAverageListenerAdded) {
      showAverageNotifier.addListener(showAverageListener);
      isShowAverageListenerAdded = true;
    }

    if (!isDevModeListenerAdded) {
      devModeNotifier.addListener(devModeListener);
      isDevModeListenerAdded = true;
    }

    if (!isEnListenerAdded) {
      isEnNotifier.addListener(isEnListener);
      isEnListenerAdded = true;
    }

    if (!isSearchCountListenerAdded) {
      searchCountNotifier.addListener(isSearchCountListener);
      isSearchCountListenerAdded = true;
    }

    if (!isListingInit.value) {
      isListingInit.value =
          true; // Must set the value to true before invoking the method
      Listing().init();
    }

    if (!isShowAnalyticsNotifierAdded) {
      showAnalyticsNotifier.addListener(showAnalyticsListener);
      isShowAnalyticsNotifierAdded = true;
    }

    if (!isChartExpandNotifierAdded) {
      chartExpandNotifier.addListener(chartExpandListener);
      isChartExpandNotifierAdded = true;
    }
  }

  void showAverageListener() {
    // Perform actions based on the new value of showAverage
    if (showAverageNotifier.value) {
      // Show the average
      Candle().computeTrendLines();
    } else {
      // Hide the average
      Candle().removeTrendLines();
    }
  }

  void devModeListener() {
    devMode.toggle();
    if (devModeNotifier.value) {
      Get.snackbar(
          'system_info'.tr,
          colorText: AppColor.whiteColor,
          backgroundColor: AppColor.greyColor,
          icon: const Icon(Icons.settings),
          'dev_mode'.tr);
      showAnalyticsNotifier.value = true;
    }
  }

  void isEnListener() {
    if (isEnNotifier.value) {
      LangService.to.changeLanguage(Lang.en);
      SubsequentAnalytics().init();
    } else {
      LangService.to.changeLanguage(Lang.zh);
      SubsequentAnalytics().init();
    }
  }

  void isSearchCountListener() {
    futureListCandledata.value = init();
  }

  void showAnalyticsListener() {
    if (showAnalyticsNotifier.value) {
      showAnalytics.value = true;
      chartExpandNotifier.value = false;
    } else {
      showAnalytics.value = false;
      chartExpandNotifier.value = true;
    }
  }

  void chartExpandListener() {
    if (chartExpandNotifier.value) {
      candleChartHeight.value = 100.h;
      expandOrShrinkIcon.value = Icons.vertical_align_center_rounded;
    } else {
      candleChartHeight.value = 50.h;
      expandOrShrinkIcon.value = Icons.expand;
    }
  }

  void reload() {
    Get.delete<MainPresenter>();
    Get.put(MainPresenter());
    logger.d('Instance "MainPresenter" has been reloaded');
    super.onInit();
  }

  Future<List<CandleData>> init() async {
    if (!alwaysShowAnalytics.value) {
      showAnalyticsNotifier.value = false;
    } else {
      showAnalyticsNotifier.value = true;
    }
    await Candle().init();
    if (showAverageNotifier.value) {
      Candle().computeTrendLines();
    }
    TrendMatch().init(init: true);
    // print(matchRows.length);
    SubsequentAnalytics().init();
    return listCandledata;
  }

  /* Route */
  void route(String path) {
    Get.toNamed(path);
  }

  void back() {
    Get.back();
  }

  /* UI Logic (mainly focused on show/hide) */
  List<Widget> buildListingRelatedIcons() {
    if (isListingInit.value) {
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
    } else {
      return [];
    }
  }

  Widget showTm() {
    return Obx(() {
      if (trendMatched.value && showAnalytics.value) {
        return TrendMatchView().showAdjustedLineChart();
      } else if (showAnalytics.value) {
        return TrendMatchView().showCircularProgressIndicator();
      }
      return const SizedBox.shrink();
    });
  }

  Widget showStartBtn() {
    return Obx(() {
      if (showAnalytics.value) {
        return const SizedBox.shrink();
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: ElevatedButton.icon(
            onPressed: () {
              MainPresenter.to.showAnalyticsNotifier.value = true;
            },
            icon: Icon(
              Icons.analytics_outlined,
              size: 20.h,
            ),
            label: Text(
              'btn_tm_sa'.tr,
              style: const TextTheme().sp5.w700,
            ),
          ),
        );
      }
    });
  }

  Widget showDevModeViewOne(bool devMode) {
    if (devMode) {
      return MainView().devModeViewOne();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showDevModeViewTwo(bool devMode) {
    if (devMode) {
      return MainView().devModeViewTwo();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showSa() {
    return Obx(() {
      if (hasSubsequentAnalytics.value &&
          showAnalytics.value &&
          devMode.value) {
        if (subsequentAnalyticsErr.value == '') {
          return Column(
            children: [
              SubsequentAnalyticsView().showSaChart(),
              SubsequentAnalyticsView().showSaDevChart(),
            ],
          );
        } else {
          return SubsequentAnalyticsView().showError();
        }
      } else if (hasSubsequentAnalytics.value && showAnalytics.value) {
        if (subsequentAnalyticsErr.value == '') {
          return SubsequentAnalyticsView().showSaChart();
        } else {
          return SubsequentAnalyticsView().showError();
        }
      } else if (showAnalytics.value) {
        return SubsequentAnalyticsView().showCircularProgressIndicator();
      }
      return const SizedBox.shrink();
    });
  }

  Widget buildListingSourceRichText() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/nasdaq.png',
            height: 6.h,
          ),
        ),
      ),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/nyse.png',
            height: 7.h,
          ),
        ),
      ),
    );
    final imageSpan3 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColor.imageDefaultBgColor,
            ),
            child: Image.asset(
              'images/amex.png',
              height: 12.h,
            ),
          ),
        ),
      ),
    );

    return RichText(
      text: TextSpan(
        text: listingsProviderMsg.value,
        children: [imageSpan, imageSpan2, imageSpan3],
        style: const TextTheme().sp4.greyColor,
      ),
    );
  }

  Widget buildMktDataProviderRichText() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/yahoofinance.png',
            height: 6.h, // Adjust the height as needed
          ),
        ),
      ),
    );

    return Obx(() => RichText(
          text: TextSpan(
            text: marketDataProviderMsg.value,
            children: [imageSpan],
            style: const TextTheme().sp4.greyColor,
          ),
        ));
  }

  Widget buildCloudFunctionCol() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/cloudfunction.png',
            height: 18.h, // Adjust the height as needed
          ),
        ),
      ),
    );
    final textSpan = WidgetSpan(
      child: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Text(
            'x',
            style: const TextTheme().sp10.greyColor,
          )),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/hsuhk_cs_dept.png',
            height: 18.h, // Adjust the height as needed
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'power_from'.tr,
            style: const TextTheme().sp4.greyColor,
          ),
        ),
        Center(
          child: RichText(
            text: TextSpan(
              children: [imageSpan, textSpan, imageSpan2],
              style: const TextTheme().sp4.greyColor,
            ),
          ),
        ),
      ],
    );
  }

  void changeAppearance() {
    darkMode.toggle();
    if (darkMode.value) {
      AppColor.primaryTextColor = Colors.white;
    } else {
      AppColor.primaryTextColor = Colors.black;
    }
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.darkMode, darkMode.value);
  }

  clearMsg() {
    messages.value = messages.sublist(0, 1); // newList will be ["first"]
    PrefsService.to.prefs
        .setStringList(SharedPreferencesConstant.messages, messages);
  }
}
