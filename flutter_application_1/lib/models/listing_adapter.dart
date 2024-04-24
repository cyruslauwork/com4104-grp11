import 'package:flutter/material.dart';
import 'package:flutter_application_1/presenters/presenters.dart';

// import 'package:flutter_application_1/utils/utils.dart';

class ListingAdapter {
  // Singleton implementation
  static final ListingAdapter _instance = ListingAdapter._();
  factory ListingAdapter() => _instance;
  ListingAdapter._();

  List<Map<String, dynamic>> jsonsToJson(
      List<Map<String, dynamic>> parsedResponses) {
    List<Map<String, dynamic>> json = [];

    try {
      for (var parsedResponse in parsedResponses) {
        var rows = parsedResponse['data']['table']['rows'];
        if (rows is List) {
          for (var row in rows) {
            if (row is Map<String, dynamic>) {
              json.add(row);
            }
          }
        }
      }
    } catch (e) {
      MainPresenter.to.listingErr.value =
          'Unable to fetch listings from api.nasdaq.com due to maintenance: $e';
    }
    // log(json.toString());
    return json;
  }

  Future<List<SymbolAndName>> jsonToSymbolAndName(
      Future<List<Map<String, dynamic>>> futureJson) async {
    List<Map<String, dynamic>> json = await futureJson;
    List<SymbolAndName> listSymbolAndName;

    listSymbolAndName = json
        .map((row) => SymbolAndName(
              symbol: row['symbol'].toString(),
              name: row['name'].toString(),
            ))
        .where((symbolAndName) =>
            !symbolAndName.symbol.contains('/') &&
            !symbolAndName.symbol.contains('^'))
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
