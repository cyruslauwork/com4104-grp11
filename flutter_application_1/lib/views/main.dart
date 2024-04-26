import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/views/views.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/services/services.dart';

class MainView extends StatefulWidget {
  // const MainView({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // Singleton implementation
  static const MainView _instance = MainView._internal();
  factory MainView() {
    return _instance;
  }
  const MainView._internal();

  Widget devModeViewOne() {
    return Column(children: [
      Column(children: [
        Text(
          'Trend Match',
          style: const TextTheme().sp5.w700,
        ),
        Obx(
          () => Table(
            border: TableBorder.all(
                color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(
                    children: [Text('DL(ms)', style: const TextTheme().sp4)]),
                Column(children: [Text('rows', style: const TextTheme().sp4)]),
                Column(children: [
                  Text('Sel count', style: const TextTheme().sp4)
                ]),
                Column(
                    children: [Text('TM rows', style: const TextTheme().sp4)]),
                Column(
                    children: [Text('Exe(ms)', style: const TextTheme().sp4)]),
                Column(children: [Text('True', style: const TextTheme().sp4)]),
                Column(children: [Text('False', style: const TextTheme().sp4)])
              ]),
              TableRow(children: [
                Column(children: [
                  Text(MainPresenter.to.candledownloadTime.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[3].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[4].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(
                      (MainPresenter.to.trendMatchOutput[3] -
                              MainPresenter.to.trendMatchOutput[4])
                          .toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[2].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[0].toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.trendMatchOutput[1].toString(),
                      style: const TextTheme().sp4)
                ]),
              ]),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Misc',
          style: const TextTheme().sp5.w700,
        ),
        Obx(
          () => Table(
            border: TableBorder.all(
                color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [
                  Text('Listing DL(ms)', style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text('SA prep(ms)', style: const TextTheme().sp4)
                ]),
                Column(
                    children: [Text('SA(ms)', style: const TextTheme().sp4)]),
                Column(children: [
                  Text('SA Cluster(s)', style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text('AI res(ms)', style: const TextTheme().sp4)
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text(MainPresenter.to.listingDownloadTime.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(
                      MainPresenter.to.lastClosePriceAndSubsequentTrendsExeTime
                          .toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.cloudSubsequentAnalyticsTime.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.numOfClusters.toString(),
                      style: const TextTheme().sp4)
                ]),
                Column(children: [
                  Text(MainPresenter.to.aiResponseTime.toString(),
                      style: const TextTheme().sp4)
                ]),
              ]),
            ],
          ),
        ),
        SizedBox(height: 10.h),
      ]),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Always show analytics',
                    style: const TextTheme().sp5.w700,
                  ),
                ),
                Switch(
                  value: MainPresenter.to.alwaysShowAnalytics.value,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    MainPresenter.to.alwaysShowAnalytics.toggle();
                    PrefsService.to.prefs.setBool(
                        SharedPreferencesConstant.alwaysShowAnalytics, value);
                  },
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      Text(
        'Percentage differences between selected period',
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          border: TableBorder.all(
              color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
          columns: MainPresenter.to.selectedPeriodPercentDifferencesList
              .mapIndexed((i, e) => DataColumn(
                      label: Text(
                    'Close Price ${(i + 1).toString()} - Close Price ${(i + 2).toString()}',
                    style: const TextTheme().sp4,
                  )))
              .toList(),
          rows: [
            DataRow(
              cells: MainPresenter.to.selectedPeriodPercentDifferencesList
                  .map((e) => DataCell(Text(
                        e.toString(),
                        style: const TextTheme().sp4,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        'Actual differences between selected period',
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          border: TableBorder.all(
              color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
          columns: MainPresenter.to.selectedPeriodActualDifferencesList
              .mapIndexed((i, e) => DataColumn(
                      label: Text(
                    'Close Price ${(i + 1).toString()} - Close Price ${(i + 2).toString()}',
                    style: const TextTheme().sp4,
                  )))
              .toList(),
          rows: [
            DataRow(
              cells: MainPresenter.to.selectedPeriodActualDifferencesList
                  .map((e) => DataCell(Text(
                        e.toString(),
                        style: const TextTheme().sp4,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        'Selected period Actual Prices',
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          border: TableBorder.all(
              color: AppColor.blackColor, style: BorderStyle.solid, width: 2),
          columns: MainPresenter.to.selectedPeriodActualPricesList
              .mapIndexed((i, e) => DataColumn(
                      label: Text(
                    'Close Price ${(i + 1).toString()}',
                    style: const TextTheme().sp4,
                  )))
              .toList(),
          rows: [
            DataRow(
              cells: MainPresenter.to.selectedPeriodActualPricesList
                  .map((e) => DataCell(Text(
                        e.toString(),
                        style: const TextTheme().sp4,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        'Matched Historical Trend Row(s)',
        style: const TextTheme().sp5.w700,
      ),
      (MainPresenter.to.matchRows.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                MainPresenter.to.matchRows.toString(),
                style: const TextTheme().sp4,
              ),
            )
          : Text('0', style: const TextTheme().sp4)),
      SizedBox(height: 10.h),
      Text(
        'Matched Historical Trend(s)',
        style: const TextTheme().sp5.w700,
      ),
      SimpleLineChart(),
      SizedBox(height: 10.h),
      Text(
        'Normalized Matched Historical Trend(s)',
        style: const TextTheme().sp5.w700,
      ),
      SimpleLineChart(
        normalized: true,
      ),
      SizedBox(height: 10.h),
    ]);
  }

  Widget devModeViewTwo() {
    return Column(children: [
      SizedBox(height: 10.h),
      Text(
        'Matched Historical Trend(s) Percentage Differences',
        style: const TextTheme().sp5.w700,
      ),
      (MainPresenter.to.matchPercentDifferencesListList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${MainPresenter.to.matchPercentDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchPercentDifferencesListList.length > 10 ? MainPresenter.to.matchPercentDifferencesListList.length - 10 : 0)} rows left',
                style: const TextTheme().sp4,
              ),
            )
          : Text('0', style: const TextTheme().sp4)),
      SizedBox(height: 10.h),
      Text(
        'Matched Historical Trend(s) Actual Differences',
        style: const TextTheme().sp5.w700,
      ),
      (MainPresenter.to.matchActualDifferencesListList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${MainPresenter.to.matchActualDifferencesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchActualDifferencesListList.length > 10 ? MainPresenter.to.matchActualDifferencesListList.length - 10 : 0)} rows left',
                style: const TextTheme().sp4,
              ),
            )
          : Text('0', style: const TextTheme().sp4)),
      SizedBox(height: 10.h),
      Text(
        'Matched Historical Trend(s) Actual Prices',
        style: const TextTheme().sp5.w700,
      ),
      (MainPresenter.to.matchActualPricesListList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${MainPresenter.to.matchActualPricesListList.mapIndexed((i, e) => '${MainPresenter.to.matchRows[i]}:$e\n').take(10).toList().toString()}...${(MainPresenter.to.matchActualPricesListList.length > 10 ? MainPresenter.to.matchActualPricesListList.length - 10 : 0)} rows left',
                style: const TextTheme().sp4,
              ),
            )
          : Text('0', style: const TextTheme().sp4)),
      SizedBox(height: 10.h),
      Text(
        'Comparison Historical Trends Percentage Differences',
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          '${MainPresenter.to.comparePeriodPercentDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodPercentDifferencesListList.length - 10} rows left',
          style: const TextTheme().sp4,
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        'Comparison Historical Trends Actual Differences',
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          '${MainPresenter.to.comparePeriodActualDifferencesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodActualDifferencesListList.length - 10} rows left',
          style: const TextTheme().sp4,
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        'Comparison Historical Trends Actual Prices',
        style: const TextTheme().sp5.w700,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          '${MainPresenter.to.comparePeriodActualPricesListList.mapIndexed((i, e) => '$i:$e\n').take(10).toList()}...${MainPresenter.to.comparePeriodActualPricesListList.length - 10} rows left',
          style: const TextTheme().sp4,
        ),
      ),
      SizedBox(height: 10.h),
    ]);
  }

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
            child: Text(
              'app_name'.tr,
              style: const TextTheme().sp7.w700,
            ),
          ),
          actions: MainPresenter.to.listCandledata.length > 1
              ? MainPresenter.to.buildListingRelatedIcons() +
                  [
                    IconButton(
                      icon: Icon(MainPresenter.to.darkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode),
                      onPressed: () => MainPresenter.to.changeAppearance(),
                    ),
                    (MainPresenter.to.devModeNotifier.value
                        ? IconButton(
                            icon: Icon(
                                MainPresenter.to.showAverageNotifier.value
                                    ? Icons.show_chart
                                    : Icons.bar_chart_outlined),
                            onPressed: () {
                              setState(() {
                                MainPresenter.to.showAverageNotifier.value =
                                    !MainPresenter.to.showAverageNotifier.value;
                              });
                            },
                          )
                        : const SizedBox.shrink()),
                    IconButton(
                      icon: Icon(MainPresenter.to.devModeNotifier.value
                          ? Icons.code
                          : Icons.code_off),
                      onPressed: () {
                        setState(() {
                          MainPresenter.to.devModeNotifier.value =
                              !MainPresenter.to.devModeNotifier.value;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(MainPresenter.to.isEnNotifier.value
                          ? Icons.g_translate
                          : Icons.translate),
                      onPressed: () {
                        MainPresenter.to.isEnNotifier.value =
                            !MainPresenter.to.isEnNotifier.value;
                        PrefsService.to.prefs.setBool(
                            SharedPreferencesConstant.isEn,
                            MainPresenter.to.isEnNotifier.value);
                      },
                    ),
                  ]
              : null,
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(2.h), // Thickness of the progress bar
            child: Obx(
              () => Visibility(
                visible: MainPresenter.to.isWaitingForReply
                    .value, // Show only when isLoading is true
                child: LinearProgressIndicator(
                  backgroundColor:
                      ThemeColor.secondary.value, // Background color
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ThemeColor.tertiary.value), // Progress color
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(1.w),
          child: FutureBuilder<List<CandleData>>(
            future: MainPresenter.to.futureListCandledata.value,
            builder: (BuildContext context,
                AsyncSnapshot<List<CandleData>> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () => MainPresenter.to.init(),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                MainPresenter.to.financialInstrumentName.value,
                                style:
                                    const TextTheme().sp7.primaryTextColor.w700,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '(${MainPresenter.to.financialInstrumentSymbol.value})',
                              style: const TextTheme().sp5.primaryTextColor,
                            ),
                          ],
                        ),
                        Text(
                          '\$${MainPresenter.to.candleListList.last[4].toString()}',
                          style: const TextTheme().sp10.primaryTextColor.w700,
                        ),
                        Text(
                          'As of ${MainPresenter.to.candleListList.last[0].toString()}.',
                          style: const TextTheme().sp4.greyColor,
                        ),
                        Center(
                          child: Text(
                            'candle_chart'.tr,
                            style: const TextTheme().sp5,
                          ),
                        ),
                        SizedBox(
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
                                // Paint()
                                //   ..strokeWidth = 1.0
                                //   ..strokeCap = StrokeCap.round
                                //   ..color = Colors.yellow,
                              ],
                              selectionHighlightColor:
                                  Colors.red.withOpacity(0.75),
                              overlayBackgroundColor:
                                  Colors.red.withOpacity(0.75),
                              overlayTextStyle:
                                  const TextStyle(color: AppColor.whiteColor),
                            ),
                            /** Callbacks */
                            // onTap: (candle) => print("user tapped on $candle"),
                          ),
                        ),
                        MainPresenter.to.buildMktDataProviderRichText(),
                        const Divider(),
                        SizedBox(height: 10.h),
                        MainPresenter.to.showDevModeViewOne(
                            MainPresenter.to.devModeNotifier.value),
                        TrendMatchView(),
                        MainPresenter.to.showDevModeViewTwo(
                            MainPresenter.to.devModeNotifier.value),
                        SizedBox(height: 10.h),
                        SubsequentAnalyticsView(context: context),
                        MainPresenter.to.buildCloudFunctionCol(),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColor.errorColor,
                        size: 40.w,
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.network(
                    //   'https://storage.googleapis.com/fplsblog/1/2020/04/line-graph.png',
                    //   fit: BoxFit.cover,
                    //   opacity: const AlwaysStoppedAnimation(.9),
                    //   color: ThemeColor.primary.value,
                    //   colorBlendMode: BlendMode.color,
                    // ),
                    Image(
                      image: const AssetImage('images/line-graph.png'),
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(.9),
                      color: ThemeColor.primary.value,
                      colorBlendMode: BlendMode.color,
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: ThemeColor.primary.value,
                        size: 25.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text('Downloading candlestick data...',
                          style: const TextTheme().sp5),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
