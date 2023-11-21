import 'dart:async';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'dart:convert';

import '../services/services.dart';
import '../controllers/controllers.dart';

var logger = Logger();

class Candle {
  Future<String> getCSV() async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    final response = await HTTPService().fetchCSV();

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    GlobalController.to.downloadTime.value = downloadTime;

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ArgumentError('Failed to fetch CSV data: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getJSON({required bool firstInit}) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    List<Map<String, dynamic>> json = [];
    DateTime currentDate = DateTime.now();

    int apiCallsPerRequest = 5;

    // firstInit is false if and only if added new JSON data
    if (!firstInit) {
      json = GlobalController.to.lastJson;
      currentDate = GlobalController.to.lastJsonEndDate.value;
    }

    for (int i = 0; i < apiCallsPerRequest; i++) {
      final String startDate = DateFormat('yyyy-MM-dd').format(
          currentDate.subtract(const Duration(
              days:
                  7))); // Each call has a maximum of 5,000 rows, which is approximately 7 days of data
      final String endDate = DateFormat('yyyy-MM-dd').format(currentDate);
      final response = await HTTPService().fetchJSON(startDate, endDate);

      if (response.statusCode == 200) {
        // firstInit is false if and only if added new JSON data
        if (firstInit) {
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
    GlobalController.to.downloadTime.value = downloadTime;

    GlobalController.to.lastJson = json; // Record the current JSON
    GlobalController.to.lastJsonEndDate.value =
        currentDate; // Record the last JSON end date

    return json;
  }

  Future<List<List<dynamic>>> checkAPIProvider({required bool firstInit}) {
    if (FlavorService.to.srcFileType == SrcFileType.csv) {
      return Candle().csvToListList(Candle().getCSV());
    } else if (FlavorService.to.srcFileType == SrcFileType.json) {
      return Candle().jsonToListList(Candle().getJSON(firstInit: firstInit));
    } else {
      throw ArgumentError('Failed to check API provider.');
    }
  }

  Future<List<List<dynamic>>> csvToListList(Future<String> futureCsv) async {
    String csv = await futureCsv;

    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csv, eol: '\n');

    // logger.d(rowsAsListOfValues);
    return rowsAsListOfValues;
  }

  Future<List<List<dynamic>>> jsonToListList(
      Future<List<Map<String, dynamic>>> futureJson) async {
    List<Map<String, dynamic>> json = await futureJson;
    List<List<dynamic>> rowsAsListOfValues = [];

    for (Map<String, dynamic> map in json) {
      List<dynamic> values = map.values.toList();
      rowsAsListOfValues.add(values);
    }

    // logger.d(rowsAsListOfValues);
    return rowsAsListOfValues;
  }

  Future<List<CandleData>> listListToCandles(
      Future<List<List<dynamic>>> futureListList) async {
    List<List<dynamic>> listList = await futureListList;
    GlobalController.to.listList.value = listList;
    List<CandleData> listCandleData;

    if (FlavorService.to.apiProvider == APIProvider.yahoofinance) {
      listList.removeAt(0);
      listCandleData = listList
          .map((row) => CandleData(
                timestamp: TimeService().convertToUnixTimestamp(row[0]) * 1000,
                open: row[1],
                high: row[2],
                low: row[3],
                close: row[4],
                volume: row[6].toDouble(),
              ))
          .toList();
      GlobalController.to.listCandleData.value = listCandleData;
      return listCandleData;
    } else if (FlavorService.to.apiProvider == APIProvider.polygon) {
      listCandleData = listList
          .map((row) => CandleData(
                timestamp: row[6],
                open: double.parse(row[2].toString()),
                high: double.parse(row[4].toString()),
                low: double.parse(row[5].toString()),
                close: double.parse(row[3].toString()),
                volume: double.parse(row[0].toString()),
              ))
          .toList();
      GlobalController.to.listCandleData.value = listCandleData;
      return listCandleData;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }
}
