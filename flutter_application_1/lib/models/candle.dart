import 'dart:async';

import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'candle_adapter.dart';

// import 'package:flutter_application_1/utils/utils.dart';

class Candle {
  // Singleton implementation
  static final Candle _instance = Candle._();
  factory Candle() => _instance;
  Candle._();

  Future<String> getCSV(int callbackTime, {required String stockSymbol}) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    final response = await HTTPService()
        .fetchCandleCSV(callbackTime, stockSymbol: stockSymbol);

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.candledownloadTime.value = downloadTime;

    if (response.statusCode == 200) {
      // print(response.body);
      // if (response.headers['content-type'] == 'text/csv') {
      // CSV object received, pass the data
      return response.body;
      // } else {
      //   return getCSV(callbackTime + 1);
      // }
    } else {
      throw ArgumentError('Failed to fetch CSV data: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getJSON({required bool init}) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    List<Map<String, dynamic>> json = [];
    DateTime currentDate = DateTime.now();

    int apiCallsPerRequest = 5;

    // init is false if and only if added new JSON data
    if (!init) {
      json = MainPresenter.to.lastJson;
      currentDate = MainPresenter.to.lastJsonEndDate.value;
    }

    for (int i = 0; i < apiCallsPerRequest; i++) {
      final String startDate = DateFormat('yyyy-MM-dd').format(
          currentDate.subtract(const Duration(
              days:
                  7))); // Each call has a maximum of 5,000 rows, which is approximately 7 days of data
      final String endDate = DateFormat('yyyy-MM-dd').format(currentDate);
      final response = await HTTPService().fetchCandleJSON(startDate, endDate);

      if (response.statusCode == 200) {
        // init is false if and only if added new JSON data
        if (init) {
          for (var map in jsonDecode(response.body)['results']) {
            if (map is Map<String, dynamic>) {
              json.add(map);
            }
          }
        } else {
          for (var map in jsonDecode(response.body)['results'].reversed) {
            if (map is Map<String, dynamic>) {
              json.insert(0, map);
            }
          }
        }
      } else {
        throw ArgumentError(
            'Failed to fetch JSON data in loop ${i.toString()}: ${response.statusCode}');
      }
      // Subtract 7 from the current date to get the next end date
      currentDate = currentDate.subtract(const Duration(days: 7));
    }

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.candledownloadTime.value = downloadTime;

    MainPresenter.to.lastJson = json; // Record the current JSON
    MainPresenter.to.lastJsonEndDate.value =
        currentDate; // Record the last JSON end date

    return json;
  }

  Future<List<List<dynamic>>> checkAPIProvider(
      {required bool init, required String stockSymbol}) {
    if (FlavorService.to.srcFileType == SrcFileType.csv) {
      return CandleAdapter().csvToListList(getCSV(0, stockSymbol: stockSymbol));
    } else if (FlavorService.to.srcFileType == SrcFileType.json) {
      return CandleAdapter().jsonToListList(getJSON(init: init));
    } else {
      throw ArgumentError('Failed to check API provider.');
    }
  }

  computeTrendLines() {
    final ma5 = CandleData.computeMA(MainPresenter.to.listCandleData, 5);
    final ma10 = CandleData.computeMA(MainPresenter.to.listCandleData, 10);
    final ma20 = CandleData.computeMA(MainPresenter.to.listCandleData, 20);
    final ma60 = CandleData.computeMA(MainPresenter.to.listCandleData, 60);
    final ma120 = CandleData.computeMA(MainPresenter.to.listCandleData, 120);
    final ma240 = CandleData.computeMA(MainPresenter.to.listCandleData, 240);
    // final vwap = _computeVWAP(MainPresenter.to.listCandleData);

    // log(vwap.toString());

    for (int i = 0; i < MainPresenter.to.listCandleData.length; i++) {
      MainPresenter.to.listCandleData[i].trends = [
        ma5[i],
        ma10[i],
        ma20[i],
        ma60[i],
        ma120[i],
        ma240[i],
        // vwap[i]
      ];
    }
  }

  // List<double?> _computeVWAP(List<CandleData> data) {
  //   final vwapList = <double?>[];
  //   double cumulativeTypicalPriceVolume = 0;
  //   double cumulativeVolume = 0;

  //   for (int i = 0; i < data.length; i++) {
  //     final candle = data[i];
  //     final typicalPrice = (candle.high! + candle.low! + candle.close!) / 3;
  //     final volume = candle.volume!;
  //     cumulativeTypicalPriceVolume += typicalPrice * volume;
  //     cumulativeVolume += volume;

  //     if (cumulativeVolume != 0) {
  //       final vwap = (cumulativeTypicalPriceVolume / cumulativeVolume) + 160;
  //       vwapList.add(vwap);
  //     } else {
  //       vwapList.add(null);
  //     }
  //   }

  //   return vwapList;
  // }

  removeTrendLines() {
    for (final data in MainPresenter.to.listCandleData) {
      data.trends = [];
    }
  }
}
