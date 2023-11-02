import 'package:csv/csv.dart';
import '../controllers/controllers.dart';

import 'package:logger/logger.dart';
import 'package:interactive_chart/interactive_chart.dart';

import '../services/services.dart';

var logger = Logger();

class CsvToListToCandleData {
  Future<List<List<dynamic>>> csvToList() async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    final response = await HTTPService().fetchCSV();
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    GlobalController().csvDownloadTime.value = downloadTime;
    if (response.statusCode == 200) {
      final csvData = response.body;
      // logger.d(csvData);
      // Process the CSV data as needed
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(csvData, eol: '\n');
      // logger.d(rowsAsListOfValues);
      return rowsAsListOfValues;
    } else {
      logger.d('Failed to fetch CSV data: ${response.statusCode}');
      return [];
    }
  }

  List<CandleData> toCandles(List<List<dynamic>> list) {
    list.removeAt(0);
    return list
        .map((row) => CandleData(
              timestamp: TimeService().convertToUnixTimestamp(row[0]),
              open: row[1],
              high: row[2],
              low: row[3],
              close: row[4],
              volume: row[6].toDouble(),
            ))
        .toList();
  }
}
