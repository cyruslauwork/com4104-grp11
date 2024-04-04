import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/l10n/lang.dart';
import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:collection/collection.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/views/views.dart';
import 'package:flutter_application_1/styles/style.dart';
import 'package:flutter_application_1/services/services.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  //const MainScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_name'.tr,
          style: const TextTheme().sp7,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.contact_support),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatView()),
              );
            },
          ),
          Obx(
            () => (MainPresenter.to.listCandleData.length > 1
                ? Row(
                    children: [
                      (MainPresenter.to.elapsedTime > 60
                          ? IconButton(
                              icon: const Icon(Icons.plus_one),
                              onPressed: () => MainPresenter.to
                                  .showSnackBar(snackBar, Func.addJson),
                            )
                          : SizedBox(
                              width: 7.w,
                              child: Text(
                                '${MainPresenter.to.elapsedTime}',
                                style: const TextTheme().sp5,
                              ),
                            )),
                      IconButton(
                        icon: Icon(MainPresenter.to.darkMode.value
                            ? Icons.dark_mode
                            : Icons.light_mode),
                        onPressed: () => MainPresenter.to.darkMode.value =
                            !MainPresenter.to.darkMode.value,
                      ),
                      (MainPresenter.to.devMode.value
                          ? IconButton(
                              icon: Icon(MainPresenter.to.showAverage.value
                                  ? Icons.show_chart
                                  : Icons.bar_chart_outlined),
                              onPressed: () {
                                MainPresenter.to.showAverage.value =
                                    !MainPresenter.to.showAverage.value;
                              },
                            )
                          : const SizedBox.shrink()),
                      IconButton(
                        icon: Icon(MainPresenter.to.devMode.value
                            ? Icons.code
                            : Icons.code_off),
                        onPressed: () => MainPresenter.to.devMode.value =
                            !MainPresenter.to.devMode.value,
                      ),
                      IconButton(
                          icon: Icon(MainPresenter.to.isEn.value
                              ? Icons.abc
                              : Icons.abc),
                          onPressed: () {
                            MainPresenter.to.isEn.value =
                                !MainPresenter.to.isEn.value;
                            if (MainPresenter.to.isEn.value) {
                              LangService.to.changeLanguage(Lang.en);
                            } else {
                              LangService.to.changeLanguage(Lang.zh);
                            }
                          }),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: SizedBox(
                      height: 5.h,
                      width: 5.w,
                      child: const CircularProgressIndicator(),
                    ),
                  )),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(5.0),
        child: FutureBuilder<List<CandleData>>(
          future: (MainPresenter.to.listCandleData.length > 1
              ? Future.value(MainPresenter.to.listCandleData)
              : MainPresenter.to.futureListCandleData),
          builder:
              (BuildContext context, AsyncSnapshot<List<CandleData>> snapshot) {
            if (snapshot.hasData) {
              Timer.periodic(const Duration(seconds: 1), (timer) {
                MainPresenter.to.elapsedTime++;
              });
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                  children: [
                    Obx(
                      () => (MainPresenter.to.devMode.value
                          ? Column(children: [
                              Text(
                                'Trend Match',
                                style: const TextTheme().sp5,
                              ),
                              Table(
                                border: TableBorder.all(
                                    color: AppColor.blackColor,
                                    style: BorderStyle.solid,
                                    width: 2),
                                children: [
                                  TableRow(children: [
                                    Column(children: [
                                      Text('True', style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text('False',
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text('Exe (ms)',
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text('Rows', style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text('Sel Count',
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text('DL (ms)',
                                          style: const TextTheme().sp3)
                                    ])
                                  ]),
                                  TableRow(children: [
                                    Column(children: [
                                      Text(
                                          MainPresenter.to.trendMatchOutput[0]
                                              .toString(),
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text(
                                          MainPresenter.to.trendMatchOutput[1]
                                              .toString(),
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text(
                                          MainPresenter.to.trendMatchOutput[2]
                                              .toString(),
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text(
                                          MainPresenter.to.trendMatchOutput[3]
                                              .toString(),
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text(
                                          MainPresenter.to.trendMatchOutput[4]
                                              .toString(),
                                          style: const TextTheme().sp3)
                                    ]),
                                    Column(children: [
                                      Text(
                                          MainPresenter.to.candledownloadTime
                                              .toString(),
                                          style: const TextTheme().sp3)
                                    ]),
                                  ]),
                                ],
                              ),
                              SizedBox(height: 10.h),
                            ])
                          : const SizedBox.shrink()),
                    ),
                    Text(
                      'Max 1000-Row Candlestick Chart',
                      style: const TextTheme().sp5,
                    ),
                    Obx(
                      () {
                        MainPresenter.to.showAverage.value
                            ? _computeTrendLines()
                            : _removeTrendLines();
                        return SizedBox(
                          width: 393.w,
                          height: 100.h,
                          child: InteractiveChart(
                            candles: (snapshot.data!.length > 1000
                                ? snapshot.data!.sublist(
                                    snapshot.data!.length - 999,
                                    snapshot.data!.length)
                                : snapshot.data!),
                            style: ChartStyle(
                              trendLineStyles: [
                                Paint()
                                  ..strokeWidth = 1.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.orange,
                                Paint()
                                  ..strokeWidth = 1.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.lightBlue,
                                Paint()
                                  ..strokeWidth = 1.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.purple[300]!,
                                Paint()
                                  ..strokeWidth = 1.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.pink[300]!,
                                Paint()
                                  ..strokeWidth = 1.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.blue[700]!,
                                Paint()
                                  ..strokeWidth = 1.0
                                  ..strokeCap = StrokeCap.round
                                  ..color = Colors.green,
                              ],
                              selectionHighlightColor:
                                  Colors.red.withOpacity(0.2),
                              overlayBackgroundColor:
                                  Colors.red.withOpacity(0.2),
                              overlayTextStyle:
                                  const TextStyle(color: AppColor.whiteColor),
                            ),
                            /** Customize axis labels */
                            // timeLabel: (timestamp, visibleDataCount) => "📅",
                            // priceLabel: (price) => "${price.round()} 💎",
                            /** Customize overlay (tap and hold to see it)
                              ** Or return an empty object to disable overlay info. */
                            // overlayInfo: (candle) => {
                            //   "💎": "🤚    ",
                            //   "Hi": "${candle.high?.toStringAsFixed(2)}",
                            //   "Lo": "${candle.low?.toStringAsFixed(2)}",
                            // },
                            /** Callbacks */
                            // onTap: (candle) => print("user tapped on $candle"),
                            // onCandleResize: (width) => print("each candle is $width wide"),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                    Obx(() => (MainPresenter.to.devMode.value
                        ? Column(children: [
                            Text(
                              'Percentage differences between selected period',
                              style: const TextTheme().sp5,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: false,
                                border: TableBorder.all(
                                    color: AppColor.blackColor,
                                    style: BorderStyle.solid,
                                    width: 2),
                                columns: MainPresenter
                                    .to.selectedPeriodPercentDifferencesList
                                    .mapIndexed((i, e) => DataColumn(
                                            label: Text(
                                          'Close Price ${(i + 1).toString()} - Close Price ${(i + 2).toString()}',
                                          style: const TextTheme().sp3,
                                        )))
                                    .toList(),
                                rows: [
                                  DataRow(
                                    cells: MainPresenter
                                        .to.selectedPeriodPercentDifferencesList
                                        .map((e) => DataCell(Text(
                                              e.toString(),
                                              style: const TextTheme().sp3,
                                            )))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Actual differences between selected period',
                              style: const TextTheme().sp5,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: false,
                                border: TableBorder.all(
                                    color: AppColor.blackColor,
                                    style: BorderStyle.solid,
                                    width: 2),
                                columns: MainPresenter
                                    .to.selectedPeriodActualDifferencesList
                                    .mapIndexed((i, e) => DataColumn(
                                            label: Text(
                                          'Close Price ${(i + 1).toString()} - Close Price ${(i + 2).toString()}',
                                          style: const TextTheme().sp3,
                                        )))
                                    .toList(),
                                rows: [
                                  DataRow(
                                    cells: MainPresenter
                                        .to.selectedPeriodActualDifferencesList
                                        .map((e) => DataCell(Text(
                                              e.toString(),
                                              style: const TextTheme().sp3,
                                            )))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Selected period Actual Prices',
                              style: const TextTheme().sp5,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: false,
                                border: TableBorder.all(
                                    color: AppColor.blackColor,
                                    style: BorderStyle.solid,
                                    width: 2),
                                columns: MainPresenter
                                    .to.selectedPeriodActualPricesList
                                    .mapIndexed((i, e) => DataColumn(
                                            label: Text(
                                          'Close Price ${(i + 1).toString()}',
                                          style: const TextTheme().sp3,
                                        )))
                                    .toList(),
                                rows: [
                                  DataRow(
                                    cells: MainPresenter
                                        .to.selectedPeriodActualPricesList
                                        .map((e) => DataCell(Text(
                                              e.toString(),
                                              style: const TextTheme().sp3,
                                            )))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Matched Historical Trend Row(s)',
                              style: const TextTheme().sp5,
                            ),
                            (MainPresenter.to.matchRows.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      MainPresenter.to.matchRows.toString(),
                                      style: const TextTheme().sp3,
                                    ),
                                  )
                                : Text('0', style: const TextTheme().sp3)),
                            SizedBox(height: 10.h),
                            Text(
                              'Matched Historical Trend(s)',
                              style: const TextTheme().sp5,
                            ),
                            SimpleLineChart(),
                            SizedBox(height: 10.h),
                            Text(
                              'Normalized Matched Historical Trend(s)',
                              style: const TextTheme().sp5,
                            ),
                            SimpleLineChart(
                              normalized: true,
                            ),
                            SizedBox(height: 10.h),
                          ])
                        : const SizedBox.shrink())),
                    Column(
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
                        AdjustedLineChart(),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => (MainPresenter.to.devMode.value
                          ? Column(children: [
                              Text(
                                'Matched Historical Trend(s) Percentage Differences',
                                style: const TextTheme().sp5,
                              ),
                              (MainPresenter.to.matchPercentDifferencesListList
                                      .isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${MainPresenter.to.matchPercentDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchPercentDifferencesListList.length > 10 ? MainPresenter.to.matchPercentDifferencesListList.length - 10 : 0)} rows left',
                                        style: const TextTheme().sp3,
                                      ),
                                    )
                                  : Text('0', style: const TextTheme().sp3)),
                              SizedBox(height: 10.h),
                              Text(
                                'Matched Historical Trend(s) Actual Differences',
                                style: const TextTheme().sp5,
                              ),
                              (MainPresenter.to.matchActualDifferencesListList
                                      .isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${MainPresenter.to.matchActualDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchActualDifferencesListList.length > 10 ? MainPresenter.to.matchActualDifferencesListList.length - 10 : 0)} rows left',
                                        style: const TextTheme().sp3,
                                      ),
                                    )
                                  : Text('0', style: const TextTheme().sp3)),
                              SizedBox(height: 10.h),
                              Text(
                                'Matched Historical Trend(s) Actual Prices',
                                style: const TextTheme().sp5,
                              ),
                              (MainPresenter
                                      .to.matchActualPricesListList.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${MainPresenter.to.matchActualPricesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchActualPricesListList.length > 10 ? MainPresenter.to.matchActualPricesListList.length - 10 : 0)} rows left',
                                        style: const TextTheme().sp3,
                                      ),
                                    )
                                  : Text('0', style: const TextTheme().sp3)),
                              SizedBox(height: 10.h),
                              Text(
                                'Comparison Historical Trends Percentage Differences',
                                style: const TextTheme().sp5,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${MainPresenter.to.comparePeriodPercentDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodPercentDifferencesListList.length - 10} rows left',
                                  style: const TextTheme().sp3,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Comparison Historical Trends Actual Differences',
                                style: const TextTheme().sp5,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${MainPresenter.to.comparePeriodActualDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodActualDifferencesListList.length - 10} rows left',
                                  style: const TextTheme().sp3,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Comparison Historical Trends Actual Prices',
                                style: const TextTheme().sp5,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${MainPresenter.to.comparePeriodActualPricesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodActualPricesListList.length - 10} rows left',
                                  style: const TextTheme().sp3,
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ])
                          : const SizedBox.shrink()),
                    ),
                    Obx(
                      () => (MainPresenter.to.subsequentAnalysis.value
                          ? (MainPresenter.to.subsequentAnalysisErr.value == ''
                              ? Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img1Bytes.value,
                                                ),
                                                minScale: 0.48,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img1',
                                          child: Image.memory(MainPresenter
                                              .to.img1Bytes.value)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img2Bytes.value,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img2',
                                          child: Image.memory(MainPresenter
                                              .to.img2Bytes.value)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img3Bytes.value,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img3',
                                          child: Image.memory(MainPresenter
                                              .to.img3Bytes.value)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img4Bytes.value,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img4',
                                          child: Image.memory(MainPresenter
                                              .to.img4Bytes.value)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img5Bytes.value,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img5',
                                          child: Image.memory(MainPresenter
                                              .to.img5Bytes.value)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img6Bytes.value,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img6',
                                          child: Image.memory(MainPresenter
                                              .to.img6Bytes.value)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: HeroPhotoViewRouteWrapper(
                                                imageProvider: MemoryImage(
                                                  MainPresenter
                                                      .to.img7Bytes.value,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Hero(
                                          tag: 'img7',
                                          child: Image.memory(MainPresenter
                                              .to.img7Bytes.value)),
                                    ),
                                  ],
                                )
                              : Text(
                                  MainPresenter.to.subsequentAnalysisErr.value,
                                  style: const TextTheme().sp5,
                                ))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: const CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text(
                                      'Awaiting subsequent trend analysis result...',
                                      style: const TextTheme().sp5),
                                ),
                              ],
                            )),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColor.errorColor,
                      size: 60.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextTheme().sp7,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://storage.googleapis.com/fplsblog/1/2020/04/line-graph.png',
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: const CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text('Downloading stock data...',
                          style: const TextTheme().sp5),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  _computeTrendLines() {
    final ma5 = CandleData.computeMA(MainPresenter.to.listCandleData, 5);
    final ma10 = CandleData.computeMA(MainPresenter.to.listCandleData, 10);
    final ma20 = CandleData.computeMA(MainPresenter.to.listCandleData, 20);
    final ma60 = CandleData.computeMA(MainPresenter.to.listCandleData, 60);
    final ma120 = CandleData.computeMA(MainPresenter.to.listCandleData, 120);
    final ma240 = CandleData.computeMA(MainPresenter.to.listCandleData, 240);

    for (int i = 0; i < MainPresenter.to.listCandleData.length; i++) {
      MainPresenter.to.listCandleData[i].trends = [
        ma5[i],
        ma10[i],
        ma20[i],
        ma60[i],
        ma120[i],
        ma240[i]
      ];
    }
  }

  _removeTrendLines() {
    for (final data in MainPresenter.to.listCandleData) {
      data.trends = [];
    }
  }
}
