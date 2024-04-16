import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presenters/presenters.dart';

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

    listList.removeAt(0); // Remove CSV column titles

    listSymbolAndName = listList
        .map((row) => SymbolAndName(
              symbol: row[0].toString(),
              name: row[1].toString(),
            ))
        .toList();
    // print(listSymbolAndName);
    return listSymbolAndName;
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
