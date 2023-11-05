import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:collection/collection.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<CandleData>> get _futureListCandleData async {
    Future<String> futureCsvData = Candle().getCSV();
    Future<List<List<dynamic>>> futureListList =
        Candle().csvToListList(futureCsvData);
    Future<List<CandleData>> futureListCandleData =
        Candle().listToCandles(futureListList);
    TrendMatch().countMatches(futureListCandleData);
    GlobalController.to.listCandleData.value = await futureListCandleData;
    return futureListCandleData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Obx(
            () => (GlobalController.to.listCandleData.length > 1
                ? Row(
                    children: [
                      IconButton(
                        icon: Icon(GlobalController.to.darkMode.value
                            ? Icons.dark_mode
                            : Icons.light_mode),
                        onPressed: () => GlobalController.to.darkMode.value =
                            !GlobalController.to.darkMode.value,
                      ),
                      // IconButton(
                      //   icon: Icon(GlobalController.to.showAverage.value
                      //       ? Icons.show_chart
                      //       : Icons.bar_chart_outlined),
                      //   onPressed: () {
                      //     GlobalController.to.showAverage.value =
                      //         !GlobalController.to.showAverage.value;
                      //   },
                      // )
                    ],
                  )
                : SizedBox(
                    height: 3.h,
                    width: 3.w,
                    child: const CircularProgressIndicator(),
                  )),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(5.0),
        child: FutureBuilder<List<CandleData>>(
          future: _futureListCandleData,
          builder:
              (BuildContext context, AsyncSnapshot<List<CandleData>> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                  children: [
                    const Text('Hello World!'),
                    Table(
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                      children: [
                        TableRow(children: [
                          Column(children: [
                            Text('True', style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text('False', style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text('Exe (ms)', style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text('Rows', style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text('Sel Count', style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text('CSV DL (ms)',
                                style: TextStyle(fontSize: 3.sp))
                          ])
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Obx(() => Text(
                                GlobalController.to.trendMatchOutput[0]
                                    .toString(),
                                style: TextStyle(fontSize: 3.sp)))
                          ]),
                          Column(children: [
                            Obx(() => Text(
                                GlobalController.to.trendMatchOutput[1]
                                    .toString(),
                                style: TextStyle(fontSize: 3.sp)))
                          ]),
                          Column(children: [
                            Obx(() => Text(
                                GlobalController.to.trendMatchOutput[2]
                                    .toString(),
                                style: TextStyle(fontSize: 3.sp)))
                          ]),
                          Column(children: [
                            Obx(() => Text(
                                GlobalController.to.trendMatchOutput[3]
                                    .toString(),
                                style: TextStyle(fontSize: 3.sp)))
                          ]),
                          Column(children: [
                            Obx(() => Text(
                                GlobalController.to.trendMatchOutput[4]
                                    .toString(),
                                style: TextStyle(fontSize: 3.sp)))
                          ]),
                          Column(children: [
                            Obx(() => Text(
                                GlobalController.to.csvDownloadTime.toString(),
                                style: TextStyle(fontSize: 3.sp)))
                          ]),
                        ]),
                      ],
                    ),
                    Obx(
                      () {
                        GlobalController.to.showAverage.value
                            ? _computeTrendLines()
                            : _removeTrendLines();
                        return SizedBox(
                          width: 393.w,
                          height: 200.h,
                          child: InteractiveChart(
                            candles: snapshot.data!,
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
                    // DataTable(
                    //   showCheckboxColumn: false,
                    //   border: TableBorder.all(
                    //       color: Colors.black,
                    //       style: BorderStyle.solid,
                    //       width: 2),
                    //   columns: GlobalController.to.selectedPeriodList
                    //       .mapIndexed((i, e) => DataColumn(
                    //               label: Text(
                    //             'Close ${(i + 1).toString()}',
                    //             style: TextStyle(fontSize: 3.sp),
                    //           )))
                    //       .toList(),
                    //   rows: [
                    //     DataRow(
                    //       cells: GlobalController.to.selectedPeriodList
                    //           .map((e) => DataCell(Text(
                    //                 e.toString(),
                    //                 style: TextStyle(fontSize: 3.sp),
                    //               )))
                    //           .toList(),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 10.h),
                    // DataTable(
                    //   showCheckboxColumn: false,
                    //   border: TableBorder.all(
                    //       color: Colors.black,
                    //       style: BorderStyle.solid,
                    //       width: 2),
                    //   columns: GlobalController.to.selectedPeriodList
                    //       .mapIndexed((i, e) => DataColumn(
                    //               label: Text(
                    //             'Close ${(i + 1).toString()}',
                    //             style: TextStyle(fontSize: 3.sp),
                    //           )))
                    //       .toList(),
                    //   rows: GlobalController.to.comparePeriodList
                    //       .map((e) => DataRow(
                    //           cells: e
                    //               .map((e) => DataCell(Text(
                    //                     e.toString(),
                    //                     style: TextStyle(fontSize: 3.sp),
                    //                   )))
                    //               .toList()))
                    //       .toList(),
                    // ),
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
    final ma7 = CandleData.computeMA(GlobalController.to.listCandleData, 7);
    final ma30 = CandleData.computeMA(GlobalController.to.listCandleData, 30);
    final ma90 = CandleData.computeMA(GlobalController.to.listCandleData, 90);

    for (int i = 0; i < GlobalController.to.listCandleData.length; i++) {
      GlobalController.to.listCandleData[i].trends = [ma7[i], ma30[i], ma90[i]];
    }
  }

  _removeTrendLines() {
    for (final data in GlobalController.to.listCandleData) {
      data.trends = [];
    }
  }
}
