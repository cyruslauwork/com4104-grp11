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
    rowsAsListOfValues.removeAt(0); // Remove CSV column titles
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

    return rowsAsListOfValues;
  }

  Future<List<CandleData>> listListTolistCandledata(
      Future<List<List<dynamic>>> futureListList) async {
    List<List<dynamic>> listList = await futureListList;
    MainPresenter.to.candleListList.value = listList;
    late List<CandleData> listCandledata;

    if (FlavorService.to.apiProvider == APIProvider.yahoofinance) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: TimeService().convertToUnixTimestamp(row[0]) * 1000,
                open: (row[1] == 'null' ? 0.0 : row[1]),
                high: (row[2] == 'null' ? 0.0 : row[2]),
                low: (row[3] == 'null' ? 0.0 : row[3]),
                close: (row[4] == 'null' ? 0.0 : row[4]),
                volume: (row[6] == 'null' ? 0.0 : row[6].toDouble()),
              ))
          .toList();
      MainPresenter.to.listCandledata.value = listCandledata;
      return listCandledata;
    } else if (FlavorService.to.apiProvider == APIProvider.polygon) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: row[6],
                open: (row[2].toString() == 'null'
                    ? 0.0
                    : double.parse(row[2].toString())),
                high: (row[4].toString() == 'null'
                    ? 0.0
                    : double.parse(row[4].toString())),
                low: (row[5].toString() == 'null'
                    ? 0.0
                    : double.parse(row[5].toString())),
                close: (row[3].toString() == 'null'
                    ? 0.0
                    : double.parse(row[3].toString())),
                volume: (row[0].toString() == 'null'
                    ? 0.0
                    : double.parse(row[0].toString())),
              ))
          .toList();
      MainPresenter.to.listCandledata.value = listCandledata;
      return listCandledata;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }
}
