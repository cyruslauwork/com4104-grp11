import 'dart:convert';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
import 'listing_adapter.dart';

class Listing {
  // Singleton implementation
  static final Listing _instance = Listing._();
  factory Listing() => _instance;
  Listing._();

  void init() async {
    MainPresenter.to.listSymbolAndName.value = [];
    List<SymbolAndName> symbolAndNameList =
        await ListingAdapter().jsonToSymbolAndName(getListingJson());
    MainPresenter.to.listSymbolAndName.value = symbolAndNameList;
    // print(symbolAndNameList);
  }

  Future<List<Map<String, dynamic>>> getListingJson() async {
    List<Map<String, dynamic>> parsedResponses = [];

    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    final responses = HTTPService().fetchListingJsons();
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.listingDownloadTime.value = downloadTime;

    await for (var response in responses) {
      // process each response
      if (response.statusCode == 200) {
        // print(response.body);
        // JSON object received, store the data
        var parsedResponse = await jsonDecode(response.body);
        parsedResponses.add(parsedResponse);
      } else {
        throw ArgumentError(
            'Failed to fetch listing JSON data: ${response.statusCode}');
      }
    }
    return ListingAdapter().jsonsToJson(parsedResponses);
  }
}
