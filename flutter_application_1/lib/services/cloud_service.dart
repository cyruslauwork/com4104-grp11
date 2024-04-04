import 'dart:convert';
import 'package:get/get.dart';

import 'package:flutter_application_1/services/services.dart';
// import 'package:flutter_application_1/utils/utils.dart';

class CloudService {
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
        {'sub_trend': encodedTrends, 'func': 'subTrendToCsvAndPng'});

    /* GET method */
    // String urlEncodedTrends = Uri.encodeComponent(encodedTrends);
    // log(urlEncodedTrends);
    // Map<String, dynamic> parsedResponse = await HTTPService().getFetchJson(
    //     'http://35.221.170.30/?func=subTrendToCsvAndPng&sub_trend=$urlEncodedTrends');
    return parsedResponse;
  }
}
