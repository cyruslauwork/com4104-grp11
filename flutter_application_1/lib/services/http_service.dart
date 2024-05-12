import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import 'time_service.dart';

// import 'package:market_ai/utils/utils.dart';

class HTTPService extends GetxService {
  // Singleton implementation
  static final HTTPService _instance = HTTPService._();
  factory HTTPService() => _instance;
  HTTPService._();

  static HTTPService get to => Get.find();

  Future<HTTPService> init() async {
    return this;
  }

  Future<http.Response> fetchCandleCsv({required String stockSymbol}) async {
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
      if (TimeService().isEasternDaylightTime(now)) {
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
    // Modify the request headers to accept JSON data
    final headers = {
      'Accept': 'application/json',
      'Connection': 'Keep-Alive',
      'Keep-Alive': 'timeout=5, max=1000',
    };

    try {
      // Make an HTTP GET request to retrieve the JSON response
      var thisUrl = Uri.parse(url);
      var response = await http.get(
        thisUrl,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsedResponse =
            await jsonDecode(response.body); // Parse the JSON response
        return parsedResponse; // Return the parsed JSON
      } else {
        var parsedErrorResponse =
            await jsonDecode(response.body); // Parse the JSON error response
        return parsedErrorResponse;
      }
    } catch (e) {
      return {'error': 'Unable to connect to $url'};
    }
  }

  Future<Map<String, dynamic>> postFetchJson(
      String url, Map<String, dynamic> body) async {
    // Modify the request headers to accept JSON data
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Connection': 'Keep-Alive',
      'Keep-Alive': 'timeout=5, max=1000',
    };

    try {
      // Make an HTTP GET request to retrieve the JSON response
      var thisUrl = Uri.parse(url);
      var response = await http.post(
        thisUrl,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log(response.body);
        var parsedResponse =
            await jsonDecode(response.body); // Parse the JSON response
        return parsedResponse; // Return the parsed JSON
      } else {
        // log(response.body);
        var parsedErrorResponse =
            await jsonDecode(response.body); // Parse the JSON error response
        return parsedErrorResponse;
      }
    } catch (e) {
      return {
        'error':
            'Trouble connecting to $url. It could be due to large data volume. Try a wider date range and smaller tolerance, or check the connection and URL.'
      };
    }
  }

  Future<String> getFetchString(String url) async {
    // Modify the request headers to accept plain text
    final headers = {
      'Accept': 'text/plain',
      'Connection': 'Keep-Alive',
      'Keep-Alive': 'timeout=5, max=1000',
    };

    try {
      // Make an HTTP GET request to retrieve the String response
      var thisUrl = Uri.parse(url);
      var response = await http.get(
        thisUrl,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'Unable to connect to $url';
    }
  }

  Future<String> postFetchString(String url, Map<String, dynamic> body) async {
    // Modify the request headers to accept plain text
    final headers = {
      'Accept': 'text/plain',
      'Connection': 'Keep-Alive',
      'Keep-Alive': 'timeout=5, max=1000',
    };

    try {
      // Make an HTTP GET request to retrieve the String response
      var thisUrl = Uri.parse(url);
      var response = await http.post(
        thisUrl,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'Unable to connect to $url';
    }
  }

  Stream<http.Response> fetchListingJsons() async* {
    // Modify the request headers to accept CSV data
    final headers = {'Accept': 'text/json'};

    var urls = [
      Uri.parse(
          'https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=99999&exchange=nasdaq'),
      Uri.parse(
          'https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=99999&exchange=nyse'),
      Uri.parse(
          'https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=99999&exchange=amex'),
      Uri.parse('http://35.221.170.30/?func=nyse-etfs-symbol-name'),
    ];

    // Send the HTTP GET request with the updated URL and headers
    for (var url in urls) {
      yield await http.get(
        url,
        headers: headers,
      );
    }
  }
}
