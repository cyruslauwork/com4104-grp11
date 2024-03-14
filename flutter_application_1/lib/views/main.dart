import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:collection/collection.dart';

import '../presenters/presenters.dart';
import '../utils/utils.dart';
import '../views/views.dart';

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
  bool _isLoading = true; // Track whether data is loading or not

  @override
  void initState() {
    super.initState();
    _loadData().then((_) {
      setState(() {
        _isLoading = false; // Set loading state to false after data is loaded
      });
    });
  }

  Future<void> _loadData() async {
    // Simulate data loading delay
    await Future.delayed(const Duration(seconds: 2));
    // Load data here
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Stock Insight'),
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
          Obx(
            () => (MainPresenter.to.listCandleData.length > 1
                ? Row(
                    children: [
                      (MainPresenter.to.elapsedTime > 60
                          ? IconButton(
                              icon: const Icon(Icons.plus_one),
                              onPressed: () =>
                                  MainPresenter.to.addJson(showSnackBar),
                            )
                          : SizedBox(
                              width: 7.w,
                              child: Text(
                                '${MainPresenter.to.elapsedTime}',
                                style: TextStyle(fontSize: 5.sp),
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
                      )
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
      body: _isLoading
          ? const SplashScreen()
          : SafeArea(
              minimum: const EdgeInsets.all(5.0),
              child: FutureBuilder<List<CandleData>>(
                future: (MainPresenter.to.listCandleData.length > 1
                    ? Future.value(MainPresenter.to.listCandleData)
                    : MainPresenter.to.futureListCandleData),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CandleData>> snapshot) {
                  if (snapshot.hasData) {
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                      MainPresenter.to.elapsedTime++;
                    });
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Set mainAxisSize to min
                        children: [
                          Obx(
                            () => (MainPresenter.to.devMode.value
                                ? Column(children: [
                                    Text(
                                      'Trend Match',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    Table(
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
                                      children: [
                                        TableRow(children: [
                                          Column(children: [
                                            Text('True',
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text('False',
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text('Exe (ms)',
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text('Rows',
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text('Sel Count',
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text('DL (ms)',
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ])
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text(
                                                MainPresenter
                                                    .to.trendMatchOutput[0]
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text(
                                                MainPresenter
                                                    .to.trendMatchOutput[1]
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text(
                                                MainPresenter
                                                    .to.trendMatchOutput[2]
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text(
                                                MainPresenter
                                                    .to.trendMatchOutput[3]
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text(
                                                MainPresenter
                                                    .to.trendMatchOutput[4]
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 3.sp))
                                          ]),
                                          Column(children: [
                                            Text(
                                                MainPresenter.to.downloadTime
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 3.sp))
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
                            style: TextStyle(fontSize: 5.sp),
                          ),
                          Obx(
                            () {
                              MainPresenter.to.showAverage.value
                                  ? _computeTrendLines()
                                  : _removeTrendLines();
                              return SizedBox(
                                width: 393.w,
                                height: 200.h,
                                child: InteractiveChart(
                                  candles: (snapshot.data!.length > 1000
                                      ? snapshot.data!.sublist(
                                          snapshot.data!.length - 999,
                                          snapshot.data!.length)
                                      : snapshot.data!),
                                  /** Example styling */
                                  // style: ChartStyle(
                                  //   priceGainColor: Colors.teal[200]!,
                                  //   priceLossColor: Colors.blueGrey,
                                  //   volumeColor: Colors.teal.withOpacity(0.8),
                                  //   trendLineStyles: [
                                  //     Paint()
                                  //       ..strokeWidth = 2.0
                                  //       ..strokeCap = StrokeCap.round
                                  //       ..color = Colors.deepOrange,
                                  //     Paint()
                                  //       ..strokeWidth = 4.0
                                  //       ..strokeCap = StrokeCap.round
                                  //       ..color = Colors.orange,
                                  //   ],
                                  //   priceGridLineColor: Colors.blue[200]!,
                                  //   priceLabelStyle: TextStyle(color: Colors.blue[200]),
                                  //   timeLabelStyle: TextStyle(color: Colors.blue[200]),
                                  //   selectionHighlightColor: Colors.red.withOpacity(0.2),
                                  //   overlayBackgroundColor: Colors.red[900]!.withOpacity(0.6),
                                  //   overlayTextStyle: TextStyle(color: Colors.red[100]),
                                  //   timeLabelHeight: 32,
                                  //   volumeHeightFactor: 0.2, // volume area is 20% of total height
                                  // ),
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
                                    style: TextStyle(fontSize: 5.sp),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
                                      columns: MainPresenter.to
                                          .selectedPeriodPercentDifferencesList
                                          .mapIndexed((i, e) => DataColumn(
                                                  label: Text(
                                                'Close Price ${(i + 1).toString()} - Close Price ${(i + 2).toString()}',
                                                style:
                                                    TextStyle(fontSize: 3.sp),
                                              )))
                                          .toList(),
                                      rows: [
                                        DataRow(
                                          cells: MainPresenter.to
                                              .selectedPeriodPercentDifferencesList
                                              .map((e) => DataCell(Text(
                                                    e.toString(),
                                                    style: TextStyle(
                                                        fontSize: 3.sp),
                                                  )))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Actual differences between selected period',
                                    style: TextStyle(fontSize: 5.sp),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
                                      columns: MainPresenter.to
                                          .selectedPeriodActualDifferencesList
                                          .mapIndexed((i, e) => DataColumn(
                                                  label: Text(
                                                'Close Price ${(i + 1).toString()} - Close Price ${(i + 2).toString()}',
                                                style:
                                                    TextStyle(fontSize: 3.sp),
                                              )))
                                          .toList(),
                                      rows: [
                                        DataRow(
                                          cells: MainPresenter.to
                                              .selectedPeriodActualDifferencesList
                                              .map((e) => DataCell(Text(
                                                    e.toString(),
                                                    style: TextStyle(
                                                        fontSize: 3.sp),
                                                  )))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Selected period Actual Prices',
                                    style: TextStyle(fontSize: 5.sp),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
                                      columns: MainPresenter
                                          .to.selectedPeriodActualPricesList
                                          .mapIndexed((i, e) => DataColumn(
                                                  label: Text(
                                                'Close Price ${(i + 1).toString()}',
                                                style:
                                                    TextStyle(fontSize: 3.sp),
                                              )))
                                          .toList(),
                                      rows: [
                                        DataRow(
                                          cells: MainPresenter
                                              .to.selectedPeriodActualPricesList
                                              .map((e) => DataCell(Text(
                                                    e.toString(),
                                                    style: TextStyle(
                                                        fontSize: 3.sp),
                                                  )))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Historical Matched Trend(s)',
                                    style: TextStyle(fontSize: 5.sp),
                                  ),
                                  (MainPresenter.to.matchRows.isNotEmpty
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            MainPresenter.to.matchRows
                                                .toString(),
                                            style: TextStyle(fontSize: 3.sp),
                                          ),
                                        )
                                      : Text('0',
                                          style: TextStyle(fontSize: 3.sp))),
                                  SimpleLineChart(),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Normalized',
                                    style: TextStyle(fontSize: 5.sp),
                                  ),
                                  SimpleLineChart(
                                    normalized: true,
                                  ),
                                  SizedBox(height: 10.h),
                                ])
                              : const SizedBox.shrink())),
                          Text(
                            'Selected trend with matched trends',
                            style: TextStyle(fontSize: 5.sp),
                          ),
                          Text(
                            '(adjusted last prices to be the same as the last selected price and apply to previous prices)',
                            style: TextStyle(fontSize: 3.sp),
                          ),
                          Text(
                            'and subsequent trends',
                            style: TextStyle(fontSize: 5.sp),
                          ),
                          Text(
                            '(adjusted first prices to be the same as the last selected price and apply to subsequent prices)',
                            style: TextStyle(fontSize: 3.sp),
                          ),
                          AdjustedLineChart(),
                          SizedBox(height: 10.h),
                          Obx(
                            () => (MainPresenter.to.devMode.value
                                ? Column(children: [
                                    Text(
                                      'Matched Trend(s) Percentage Differences',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    (MainPresenter
                                            .to
                                            .matchPercentDifferencesListList
                                            .isNotEmpty
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              '${MainPresenter.to.matchPercentDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(100).toList().toString()}...${(MainPresenter.to.matchPercentDifferencesListList.length > 100 ? MainPresenter.to.matchPercentDifferencesListList.length - 100 : 0)} rows left',
                                              style: TextStyle(fontSize: 3.sp),
                                            ),
                                          )
                                        : Text('0',
                                            style: TextStyle(fontSize: 3.sp))),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Matched Trend(s) Actual Differences',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    (MainPresenter
                                            .to
                                            .matchActualDifferencesListList
                                            .isNotEmpty
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              '${MainPresenter.to.matchActualDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(100).toList().toString()}...${(MainPresenter.to.matchActualDifferencesListList.length > 100 ? MainPresenter.to.matchActualDifferencesListList.length - 100 : 0)} rows left',
                                              style: TextStyle(fontSize: 3.sp),
                                            ),
                                          )
                                        : Text('0',
                                            style: TextStyle(fontSize: 3.sp))),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Matched Trend(s) Actual Prices',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    (MainPresenter.to.matchActualPricesListList
                                            .isNotEmpty
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              '${MainPresenter.to.matchActualPricesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(100).toList().toString()}...${(MainPresenter.to.matchActualPricesListList.length > 100 ? MainPresenter.to.matchActualPricesListList.length - 100 : 0)} rows left',
                                              style: TextStyle(fontSize: 3.sp),
                                            ),
                                          )
                                        : Text('0',
                                            style: TextStyle(fontSize: 3.sp))),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Comparison Trends Percentage Differences',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${MainPresenter.to.comparePeriodPercentDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(100).toList()}...${MainPresenter.to.comparePeriodPercentDifferencesListList.length - 100} rows left',
                                        style: TextStyle(fontSize: 3.sp),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Comparison Trends Actual Differences',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${MainPresenter.to.comparePeriodActualDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(100).toList()}...${MainPresenter.to.comparePeriodActualDifferencesListList.length - 100} rows left',
                                        style: TextStyle(fontSize: 3.sp),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Comparison Trends Actual Prices',
                                      style: TextStyle(fontSize: 5.sp),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${MainPresenter.to.comparePeriodActualPricesListList.mapIndexed((i, e) => '$i:$e\n').take(100).toList()}...${MainPresenter.to.comparePeriodActualPricesListList.length - 100} rows left',
                                        style: TextStyle(fontSize: 3.sp),
                                      ),
                                    ),
                                  ])
                                : const SizedBox.shrink()),
                          ),
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
                            color: Colors.red,
                            size: 60.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontSize: 10.sp),
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
                          SizedBox(
                            width: 40.w,
                            height: 40.h,
                            child: const CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text('Awaiting result...',
                                style: TextStyle(fontSize: 10.sp)),
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

  _computeTrendLines() {
    final ma5 = CandleData.computeMA(MainPresenter.to.listCandleData, 5);
    final ma10 = CandleData.computeMA(MainPresenter.to.listCandleData, 10);
    final ma20 = CandleData.computeMA(MainPresenter.to.listCandleData, 20);

    for (int i = 0; i < MainPresenter.to.listCandleData.length; i++) {
      MainPresenter.to.listCandleData[i].trends = [ma5[i], ma10[i], ma20[i]];
    }
  }

  _removeTrendLines() {
    for (final data in MainPresenter.to.listCandleData) {
      data.trends = [];
    }
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://storage.googleapis.com/fplsblog/1/2020/04/line-graph.png',
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
