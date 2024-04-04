import 'package:csv/csv.dart';
import 'package:interactive_chart/interactive_chart.dart';

import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/presenters/presenters.dart';

class CandleAdapter {
  // Singleton implementation
  static final CandleAdapter _instance = CandleAdapter._();
  factory CandleAdapter() => _instance;
  CandleAdapter._();

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
    MainPresenter.to.candleListList.value = listList;
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
      MainPresenter.to.listCandleData.value = listCandleData;
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
      MainPresenter.to.listCandleData.value = listCandleData;
      return listCandleData;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }
}
