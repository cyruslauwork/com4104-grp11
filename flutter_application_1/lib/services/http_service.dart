import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:flutter_application_1/utils/utils.dart';

class HTTPService extends GetxService {
  // Singleton implementation
  static final HTTPService _instance = HTTPService._();
  factory HTTPService() => _instance;
  HTTPService._();

  static HTTPService get to => Get.find();

  Future<HTTPService> init() async {
    return this;
  }

  Future<http.Response> fetchCandleCSV(int callbackTime,
      {required String stockSymbol}) async {
    /* 
    US exchanges – such as the NYSE or NASDAQ – which are open Monday through Friday from 9:30 am to 4:00 pm Eastern Daylight Time (GMT-04:00) i.e. 14:30 to 21:00 (UTC).
    Eastern Standard Time (Winter Time) or EST: It is 5 hours behind the Greenwich Mean Time/Coordinated Universal Time or UTC-5. 
    Eastern Daylight Time or EDT: In summer and spring seasons, daylight saving time is observed. EDT is 4 hours behind UTC or UTC-4.
    */
    int startTimestamp = 0;
    // DateTime.utc(2023, 10, 1, 0, 0, 0).millisecondsSinceEpoch ~/1000; // e.g. DateTime(2017, 9, 7, 17, 30, 0); 7th of September 2017, 05:30:00pm
    int endTimestamp;
    // Latest, based on the closing price on the trading day
    DateTime now = DateTime.now().toUtc();
    // Check if current UTC time is less than or equal to 13:30:50
    if (now.hour < 13 ||
        (now.hour == 13 && now.minute <= 30 && now.second <= 50)) {
      endTimestamp = 9999999999;
    } else {
      if (isEasternDaylightTime(now)) {
        // Check if current UTC time is greater than or equal to 20:00 in Eastern Daylight Time (USA summer and spring seasons)
        if (now.hour >= 20) {
          endTimestamp = 9999999999;
        } else {
          // Set endTimestamp to current UTC time minus 12 hours
          endTimestamp =
              now.subtract(const Duration(hours: 12)).millisecondsSinceEpoch ~/
                  1000;
        }
      } else {
        // Check if current UTC time is greater than or equal to 21:00 in Eastern Standard Time
        if (now.hour >= 21) {
          endTimestamp = 9999999999;
        } else {
          // Set endTimestamp to current UTC time minus 12 hours
          endTimestamp =
              now.subtract(const Duration(hours: 12)).millisecondsSinceEpoch ~/
                  1000;
        }
      }
    }
    // endTimestamp =
    //     9999999999; // Latest, but closing prices may vary during trading sessions
    // endTimestamp =
    //     1701360000; // The end date of iconic 5-day trend matching subsequent trends
    // endTimestamp =
    //     DateTime.utc(2024, 4, 15, 23, 59, 59).millisecondsSinceEpoch ~/
    //         1000; // Select specific end date

    final url = Uri.parse(
        'https://query1.finance.yahoo.com/v7/finance/download/$stockSymbol?period1=$startTimestamp&period2=$endTimestamp&interval=1d&events=history&includeAdjustedClose=true');
    /* 
    Maximum end timestamp: 9999999999

    Possible inputs for &interval= (download): 1d, 5d, 1wk, 1mo, 3mo
    Possible inputs for &interval= (chart): 1m, 5m, 15m, 30m, 90m, 1h, 1d, 5d, 1wk, 1mo, 3mo
    
    m (minute) intervals are limited to 30days with period1 and period2 spaning a maximum of 7 days per/request. 
    Exceeding either of these limits will result in an error and will not round
    
    h (hour) interval is limited to 730days with no limit to span. Exceeding this will result in an error and will not round
    */

    // Modify the request headers to accept CSV data
    final headers = {'Accept': 'text/csv'};

    // Send the HTTP GET request with the updated URL and headers
    return http.get(url, headers: headers);
  }

  Future<http.Response> fetchCandleJSON(String dateFrom, String dateTo) async {
    final url = Uri.parse(
        'https://api.polygon.io/v2/aggs/ticker/SPY/range/1/minute/$dateFrom/$dateTo?sort=asc&apiKey=euww4YBOgQXqtrfpubOCAYnlQJrOY22N');

    /* 
    The intraday candles json up to 5000 results each API call (about 7 days) and there are 5 free API calls per minute.
    */

    // Modify the request headers to accept JSON data
    final headers = {'Accept': 'text/json'};

    // Send the HTTP GET request with the updated URL and headers
    return http.get(url, headers: headers);
  }

  Future<Map<String, dynamic>> getFetchJson(String url) async {
    // Make an HTTP GET request to retrieve the JSON response
    var thisUrl = Uri.parse(url);
    var response = await http.get(thisUrl);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var parsedResponse =
          await jsonDecode(response.body); // Parse the JSON response
      // print(response.body.runtimeType);
      return parsedResponse; // Return the parsed JSON
    } else {
      var parsedErrorResponse =
          await jsonDecode(response.body); // Parse the JSON error response
      logger.d('${response.statusCode}, $parsedErrorResponse');
      return parsedErrorResponse;
    }
  }

  Future<Map<String, dynamic>> postFetchJson(
      String url, Map<String, dynamic> body) async {
    // Make an HTTP GET request to retrieve the JSON response
    var thisUrl = Uri.parse(url);
    var response = await http.post(
      thisUrl,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var parsedResponse =
          await jsonDecode(response.body); // Parse the JSON response
      // print(response.body.runtimeType);
      return parsedResponse; // Return the parsed JSON
    } else {
      var parsedErrorResponse =
          await jsonDecode(response.body); // Parse the JSON error response
      logger.d('${response.statusCode}, $parsedErrorResponse');
      return parsedErrorResponse;
    }
  }

  Future<String> getFetchString(String url) async {
    // Make an HTTP GET request to retrieve the String response
    var thisUrl = Uri.parse(url);
    var response = await http.get(thisUrl);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(response.body.runtimeType);
      return response.body;
    } else {
      logger.d('${response.statusCode}, $response.body');
      return response.body;
    }
  }

  Future<String> postFetchString(String url, Map<String, dynamic> body) async {
    // Make an HTTP GET request to retrieve the String response
    var thisUrl = Uri.parse(url);
    var response = await http.post(
      thisUrl,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(response.body.runtimeType);
      return response.body;
    } else {
      logger.d('${response.statusCode}, $response.body');
      return response.body;
    }
  }

  Future<http.Response> fetchListingCSV() async {
    final url = Uri.parse(
        'https://r2.datahub.io/clt98kj4f0005ia08b4a7ergo/master/raw/data/nasdaq-listed-symbols.csv');

    // Modify the request headers to accept CSV data
    final headers = {'Accept': 'text/csv'};

    // Send the HTTP GET request with the updated URL and headers
    return http.get(url, headers: headers);
  }
}

bool isEasternDaylightTime(DateTime dateTime) {
  int year = dateTime.year;
  DateTime startDst = DateTime.utc(year, 3, (14 - (5 * year ~/ 4 + 1) % 7), 2);
  DateTime endDst = DateTime.utc(year, 11, (7 - (5 * year ~/ 4 + 1) % 7), 2);
  return dateTime.isAfter(startDst) && dateTime.isBefore(endDst);
}

bool isEasternStandardTime(DateTime dateTime) {
  return !isEasternDaylightTime(dateTime);
}
