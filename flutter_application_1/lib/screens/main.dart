import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';

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
  Future<List<CandleData>> get _futureCandleData async {
    Future<String> futureCsvData = Candle().getCSV();
    Future<List<List<dynamic>>> futureList = Candle().csvToList(futureCsvData);
    Future<List<CandleData>> futureCandleData =
        Candle().listToCandles(futureList);
    _trendMatchOutput = await TrendMatch().countMatches(futureCandleData);
    return futureCandleData;
  }

  late List<int> _trendMatchOutput;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = true;
    bool showAverage = false;

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        actions: [
          FutureBuilder<List<CandleData>>(
              future: _futureCandleData,
              builder: (context, AsyncSnapshot<List<CandleData>> snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      IconButton(
                        icon:
                            Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
                        onPressed: () => setState(() => darkMode = !darkMode),
                      ),
                      IconButton(
                        icon: Icon(
                          showAverage
                              ? Icons.show_chart
                              : Icons.bar_chart_outlined,
                        ),
                        onPressed: () {
                          setState(() => showAverage = !showAverage);
                          if (showAverage) {
                            _computeTrendLines(snapshot.data!);
                          } else {
                            _removeTrendLines(snapshot.data!);
                          }
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24.0),
        child: FutureBuilder<List<CandleData>>(
          future: _futureCandleData,
          builder: (context, AsyncSnapshot<List<CandleData>> snapshot) {
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
                            Text('Selected Count',
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text('CSV DL (ms)',
                                style: TextStyle(fontSize: 3.sp))
                          ])
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Text(_trendMatchOutput[0].toString(),
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text(_trendMatchOutput[1].toString(),
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text(_trendMatchOutput[2].toString(),
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text(_trendMatchOutput[3].toString(),
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text(_trendMatchOutput[4].toString(),
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                          Column(children: [
                            Text(
                                GlobalController()
                                    .csvDownloadTime
                                    .value
                                    .toString(),
                                style: TextStyle(fontSize: 3.sp))
                          ]),
                        ]),
                      ],
                    ),
                    SizedBox(
                      width: 393.w,
                      height: 200.h,
                      child: InteractiveChart(
                        /** Only [candles] is required */
                        candles: snapshot.data!,
                        /** Uncomment the following for examples on optional parameters */

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
                    ),
                    SizedBox(height: 10.h),
                    // DataTable(
                    //     showCheckboxColumn: false,
                    //     border: TableBorder.all(
                    //         color: Colors.black, style: BorderStyle.solid, width: 2),
                    //     columns:
                    //         // _selectedPeriodList.map((e) => const DataColumn(label: Text(""))).toList(),
                    //         const [DataColumn(label: Text(""))],
                    //     rows: _selectedPeriodList
                    //         .map((e) => DataRow(cells: [
                    //               DataCell(Text(e.toString(),
                    //                   style: TextStyle(fontSize: 3.sp)))
                    //             ]))
                    //         .toList()),
                    SizedBox(height: 10.h),
                    // DataTable(
                    //     showCheckboxColumn: false,
                    //     border: TableBorder.all(
                    //         color: Colors.black, style: BorderStyle.solid, width: 2),
                    //     columns: columns,
                    //     rows: rows)
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
                      width: 60.w,
                      height: 60.h,
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

  _computeTrendLines(List<CandleData> candleData) async {
    final ma7 = CandleData.computeMA(candleData, 7);
    final ma30 = CandleData.computeMA(candleData, 30);
    final ma90 = CandleData.computeMA(candleData, 90);

    for (int i = 0; i < candleData.length; i++) {
      candleData[i].trends = [ma7[i], ma30[i], ma90[i]];
    }
  }

  _removeTrendLines(List<CandleData> candleData) async {
    for (final data in candleData) {
      data.trends = [];
    }
  }
}
