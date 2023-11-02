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
  List<CandleData> _candleData = [
    CandleData(
        timestamp: 1556026200,
        open: 52.03,
        high: 53.12,
        low: 51.15,
        close: 52.78,
        volume: 54719500),
    CandleData(
        timestamp: 1556112600,
        open: 52.77,
        high: 53.06,
        low: 51.60,
        close: 51.73,
        volume: 53637500),
    CandleData(
        timestamp: 1556199000,
        open: 51.00,
        high: 51.80,
        low: 49.21,
        close: 49.53,
        volume: 109247000),
    CandleData(
        timestamp: 1556285400,
        open: 49.30,
        high: 49.34,
        low: 46.23,
        close: 47.03,
        volume: 111803500),
    CandleData(
        timestamp: 1556544600,
        open: 47.17,
        high: 48.80,
        low: 46.43,
        close: 48.29,
        volume: 83572500),
    CandleData(
        timestamp: 1556631000,
        open: 48.41,
        high: 48.84,
        low: 47.40,
        close: 47.74,
        volume: 47323000),
    CandleData(
        timestamp: 1556717400,
        open: 47.77,
        high: 48.00,
        low: 46.30,
        close: 46.80,
        volume: 53522000),
    CandleData(
        timestamp: 1556803800,
        open: 49.10,
        high: 49.43,
        low: 47.54,
        close: 48.82,
        volume: 90796500),
    CandleData(
        timestamp: 1556890200,
        open: 48.77,
        high: 51.32,
        low: 48.70,
        close: 51.01,
        volume: 118534000),
    CandleData(
        timestamp: 1557149400,
        open: 50.00,
        high: 51.67,
        low: 49.70,
        close: 51.07,
        volume: 54169500),
    CandleData(
        timestamp: 1557235800,
        open: 51.36,
        high: 51.44,
        low: 49.02,
        close: 49.41,
        volume: 50657000),
    CandleData(
        timestamp: 1557322200,
        open: 49.39,
        high: 50.12,
        low: 48.84,
        close: 48.97,
        volume: 30882000),
    CandleData(
        timestamp: 1557408600,
        open: 48.40,
        high: 48.74,
        low: 47.39,
        close: 48.40,
        volume: 33557000),
    CandleData(
        timestamp: 1557495000,
        open: 47.95,
        high: 48.40,
        low: 47.20,
        close: 47.90,
        volume: 35041500),
    CandleData(
        timestamp: 1557754200,
        open: 46.40,
        high: 46.49,
        low: 44.90,
        close: 45.40,
        volume: 54174000),
    CandleData(
        timestamp: 1557840600,
        open: 45.86,
        high: 46.90,
        low: 45.60,
        close: 46.46,
        volume: 36262000),
    CandleData(
        timestamp: 1557927000,
        open: 45.86,
        high: 46.49,
        low: 45.05,
        close: 46.39,
        volume: 36480000),
    CandleData(
        timestamp: 1558013400,
        open: 45.90,
        high: 46.20,
        low: 45.30,
        close: 45.67,
        volume: 37416500),
    CandleData(
        timestamp: 1558099800,
        open: 44.39,
        high: 44.45,
        low: 41.78,
        close: 42.21,
        volume: 88933500),
    CandleData(
        timestamp: 1558359000,
        open: 40.56,
        high: 41.20,
        low: 39.05,
        close: 41.07,
        volume: 102631000),
    CandleData(
        timestamp: 1558445400,
        open: 39.55,
        high: 41.48,
        low: 39.21,
        close: 41.02,
        volume: 90019500),
  ];

  @override
  void initState() {
    super.initState();
    initCandleData();
  }

  void initCandleData() async {
    List<List<dynamic>> list = await CsvToListToCandleData().csvToList();
    setState(() {
      _candleData = CsvToListToCandleData().toCandles(list);
    });
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
          IconButton(
            icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => setState(() => darkMode = !darkMode),
          ),
          IconButton(
            icon: Icon(
              showAverage ? Icons.show_chart : Icons.bar_chart_outlined,
            ),
            onPressed: () {
              setState(() => showAverage = !showAverage);
              if (showAverage) {
                _computeTrendLines();
              } else {
                _removeTrendLines();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
          children: [
            const Text('Hello World!'),
            const Text('True | False | Execute (ms) | CSV Download (ms)'),
            Text(countMatches().toString() +
                GlobalController().csvDownloadTime.value.toString()),
            SizedBox(
              width: 393.w,
              height: 200.h,
              child: InteractiveChart(
                /** Only [candles] is required */
                candles: _candleData,
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
          ],
        ),
      ),
    );
  }

  List<int> countMatches() {
    int trueCount = 0;
    int falseCount = 0;
    List<double> lastFive = [];
    DateTime startTime = DateTime.now(); // Record the start time
    for (int i = 4; i > 0; i--) {
      double percentage = (_candleData[_candleData.length - (i + 1)].close! -
              _candleData[_candleData.length - i].close!) /
          (_candleData[_candleData.length - i].close!);
      lastFive.add(percentage);
    }
    //loop all data with lastfive
    for (int l = 0; l < _candleData.length - 5; l++) {
      //-5 to avoid counting last five data as a same match
      List<double> compareFive = [];
      for (int i = 0; i < 4; i++) {
        double percentage =
            (_candleData[l + (i + 1)].close! - _candleData[l + i].close!) /
                (_candleData[l + i].close!);
        compareFive.add(percentage);
      }
      if (areDifferencesLargerThan30Percent(lastFive, compareFive)) {
        //find match five data
        falseCount += 1;
      } else {
        trueCount += 1;
      }
    }
    DateTime endTime = DateTime.now(); // Record the end time
    // Calculate the time difference
    Duration executionDuration = endTime.difference(startTime);
    int executionTime = executionDuration.inMilliseconds;
    return [trueCount, falseCount, (executionTime)];
  }

  bool areDifferencesLargerThan30Percent(
      List<double> list1, List<double> list2) {
    if (list1.length != list2.length) {
      throw ArgumentError("Both lists must have the same length.");
    }

    for (int i = 0; i < list1.length; i++) {
      double difference = list1[i] - list2[i];
      double percentageDifference = (difference / list1[i]) * 100;

      if (percentageDifference.abs() <= 30) {
        return false; // Difference is not larger than 30%
      }
    }

    return true; // All differences are larger than 30%
  }

  _compareData() {
    List<double> lastFive = [];
    for (int i = 5; i < 0; i--) {
      double percentage = (_candleData[_candleData.length - i + 1].close! -
              _candleData[_candleData.length - i].close!) /
          (_candleData[_candleData.length - i].close!);
      lastFive.add(percentage);
    }
    //loop all data with lastfive
  }

  _computeTrendLines() {
    final ma7 = CandleData.computeMA(_candleData, 7);
    final ma30 = CandleData.computeMA(_candleData, 30);
    final ma90 = CandleData.computeMA(_candleData, 90);

    for (int i = 0; i < _candleData.length; i++) {
      _candleData[i].trends = [ma7[i], ma30[i], ma90[i]];
    }
  }

  _removeTrendLines() {
    for (final data in _candleData) {
      data.trends = [];
    }
  }
}
