import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
import 'listing_adapter.dart';

class Listing {
  // Singleton implementation
  static final Listing _instance = Listing._();
  factory Listing() => _instance;
  Listing._();

  void init() async {
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
