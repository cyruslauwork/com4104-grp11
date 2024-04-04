import 'dart:async';

import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'candle_adapter.dart';

class Candle {
  // Singleton implementation
  static final Candle _instance = Candle._();
  factory Candle() => _instance;
  Candle._();

  Future<String> getCSV(int callbackTime) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    final response = await HTTPService().fetchCandleCSV(callbackTime);

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

  Future<List<List<dynamic>>> checkAPIProvider({required bool init}) {
    if (FlavorService.to.srcFileType == SrcFileType.csv) {
      return CandleAdapter().csvToListList(getCSV(0));
    } else if (FlavorService.to.srcFileType == SrcFileType.json) {
      return CandleAdapter().jsonToListList(getJSON(init: init));
    } else {
      throw ArgumentError('Failed to check API provider.');
    }
  }
}
