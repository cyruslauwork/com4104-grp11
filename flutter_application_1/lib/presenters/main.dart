import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/views/views.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';

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
  RxBool darkMode = true.obs;
  ValueNotifier<bool> devMode = ValueNotifier<bool>(false);
  ValueNotifier<bool> isEn = ValueNotifier<bool>(true);

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

  /* Listing-related */
  RxInt listingDownloadTime = 0.obs;
  RxList<List<dynamic>> symbolAndNameListList = [[]].obs;
  RxList<SymbolAndName> listSymbolAndName =
      [const SymbolAndName(symbol: '', name: '')].obs;
  ValueNotifier<int> searchCount = ValueNotifier<int>(0);
  RxInt aiResponseTime = 0.obs;

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
        showSnackBar(func: Func.devMode);
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

  /* UI */
  void showSnackBar({Func? func, String? title, String? msg}) {
    if (title != null && msg != null) {
      Get.snackbar(title, msg);
    }
    if (func == Func.devMode) {
      Get.snackbar("Information", 'Developer mode is on');
    } else {
      throw ArgumentError('Error: Failed to get function name.');
    }
  }

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected trend with matched historical trends',
              style: const TextTheme().sp5,
            ),
            Text(
              '(adjusted last prices to be the same as the last selected price and apply to previous prices)',
              style: const TextTheme().sp3,
            ),
            Text(
              'and their subsequent trends',
              style: const TextTheme().sp5,
            ),
            Text(
              '(adjusted first prices to be the same as the last selected price and apply to subsequent prices)',
              style: const TextTheme().sp3,
            ),
            AdjustedLineChart()
          ],
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: const CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text('Trend matching...', style: const TextTheme().sp5),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget showSa(BuildContext context) {
    return Obx(() {
      if (hasSubsequentAnalysis.value) {
        if (subsequentAnalysisErr.value == '') {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img1Bytes.value,
                          ),
                          minScale: 0.48,
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img1', child: Image.memory(img1Bytes.value)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img2Bytes.value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img2', child: Image.memory(img2Bytes.value)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img3Bytes.value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img3', child: Image.memory(img3Bytes.value)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img4Bytes.value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img4', child: Image.memory(img4Bytes.value)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img5Bytes.value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img5', child: Image.memory(img5Bytes.value)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img6Bytes.value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img6', child: Image.memory(img6Bytes.value)),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: MemoryImage(
                            img7Bytes.value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(tag: 'img7', child: Image.memory(img7Bytes.value)),
              ),
            ],
          );
        } else {
          return Text(
            subsequentAnalysisErr.value,
            style: const TextTheme().sp5,
          );
        }
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: const CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text('Awaiting subsequent trend analysis result...',
                    style: const TextTheme().sp5),
              ),
            ],
          ),
        );
      }
    });
  }
}
