import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presenters/main.dart';
import 'package:flutter_application_1/services/services.dart';

class ListingAdapter {
  // Singleton implementation
  static final ListingAdapter _instance = ListingAdapter._();
  factory ListingAdapter() => _instance;
  ListingAdapter._();

  Future<List<List<dynamic>>> csvToListList(Future<String> futureCsv) async {
    String csv = await futureCsv;

    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csv, eol: '\n');

    // print(rowsAsListOfValues);
    return rowsAsListOfValues;
  }

  Future<List<SymbolAndName>> listListToSymbolAndName(
      Future<List<List<dynamic>>> futureListList) async {
    List<List<dynamic>> listList = await futureListList;
    MainPresenter.to.symbolAndNameListList.value = listList;
    List<SymbolAndName> listSymbolAndName;

    listList = [];
    listSymbolAndName = listList
        .map((row) => SymbolAndName(
              symbol: row[0].toString(),
              name: row[1].toString(),
            ))
        .toList();
    MainPresenter.to.listSymbolAndName.value = listSymbolAndName;
    return listSymbolAndName;
  }

  void initListing() async {
    List<SymbolAndName> symbolAndNameList = await ListingAdapter()
        .listListToSymbolAndName(
            ListingAdapter().csvToListList(getListingCSV()));
    MainPresenter.to.symbolAndNameList.value = symbolAndNameList;
  }

  Future<String> getListingCSV() async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    final response = await HTTPService().fetchListingCSV();
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.listingDownloadTime.value = downloadTime;
    if (response.statusCode == 200) {
      // print(response.body);
      // CSV object received, pass the data
      return response.body;
    } else {
      throw ArgumentError('Failed to fetch CSV data: ${response.statusCode}');
    }
  }
}

@immutable
class SymbolAndName {
  final String symbol, name;

  const SymbolAndName({required this.symbol, required this.name});

  @override
  String toString() {
    return '$symbol, $name';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SymbolAndName &&
        other.symbol == symbol &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(name, symbol);
}
