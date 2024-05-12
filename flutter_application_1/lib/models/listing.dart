import 'dart:convert';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/services/services.dart';
import 'listing_adapter.dart';

class Listing {
  // Singleton implementation
  static final Listing _instance = Listing._();
  factory Listing() => _instance;
  Listing._();

  void init() {
    MainPresenter.to.listSymbolAndName.value = [];
    ListingAdapter().jsonToSymbolAndName(getListingJson()).then(
        (symbolAndNameList) =>
            MainPresenter.to.listSymbolAndName.value = symbolAndNameList);
  }

  Future<List<Map<String, dynamic>>> getListingJson() async {
    List<Map<String, dynamic>> parsedResponses = [];
    List<String> errorResponseStatus = [];

    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    final responses = HTTPService().fetchListingJsons();
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.listingsDownloadTime.value = downloadTime;

    try {
      await for (var response in responses) {
        // process each response
        if (response.statusCode == 200 || response.statusCode == 201) {
          // JSON object received, store the data
          var parsedResponse = await jsonDecode(response.body);
          parsedResponses.add(parsedResponse);
        } else {
          errorResponseStatus.add(response.statusCode.toString());
        }
      }
    } catch (e) {
      MainPresenter.to.listingsProviderMsg.value =
          '${errorResponseStatus.toString()}: Failed to fetch listings from';
      MainPresenter.to.isListingsProviderErr.value = true;
    }
    return ListingAdapter().jsonsToJson(parsedResponses);
  }
}
