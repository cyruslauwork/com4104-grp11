import 'dart:convert';
import 'package:get/get.dart';

import 'package:flutter_application_1/services/services.dart';

// import 'package:flutter_application_1/utils/utils.dart';

class CloudService extends GetxService {
  // Singleton implementation
  static final CloudService _instance = CloudService._();
  factory CloudService() => _instance;
  CloudService._();

  static HTTPService get to => Get.find();

  Future<CloudService> init() async {
    return this;
  }

  Future<Map<String, dynamic>> getCsvAndPng(
      List<List<double>> lastClosePriceAndSubsequentTrends) async {
    String encodedTrends = jsonEncode(lastClosePriceAndSubsequentTrends);
    // log(encodedTrends);

    /* POST method */
    Map<String, dynamic> parsedResponse = await HTTPService().postFetchJson(
        'http://35.221.170.30/',
        {'sub_trend': encodedTrends, 'func': 'subtrend-to-csv-png'});

    /* GET method */
    // String urlEncodedTrends = Uri.encodeComponent(encodedTrends);
    // log(urlEncodedTrends);
    // Map<String, dynamic> parsedResponse = await HTTPService().getFetchJson(
    //     'http://35.221.170.30/?func=subtrend-to-csv-png&sub_trend=$urlEncodedTrends');
    return parsedResponse;
  }

  Future<String> getNewsAnalytics(
      {String? symbolAndName, String? symbols, String? question}) async {
    if (symbolAndName != null) {
      /* GET method */
      String urlEncodedSymbolAndName = Uri.encodeComponent(symbolAndName);
      // log(urlEncodedSymbolAndName);
      String response = await HTTPService().getFetchString(
          'http://35.221.170.30/?func=gemini-pro-news&symbol_and_name=$urlEncodedSymbolAndName');
      return response;
    } else if (symbols != null && question != null) {
      /* GET method */
      String urlEncodedSymbols = Uri.encodeComponent(symbols);
      String urlEncodedQuestion = Uri.encodeComponent(question);
      // log(urlEncodedSymbols);
      // log(urlEncodedQuestion);
      String response = await HTTPService().getFetchString(
          'http://35.221.170.30/?func=gemini-pro-news-custom&symbols=$urlEncodedSymbols&question=$urlEncodedQuestion');
      return response;
    } else {
      throw ArgumentError(
          'Must have correct passing parameter value(s) to fetch news analytics.');
    }
  }
}
