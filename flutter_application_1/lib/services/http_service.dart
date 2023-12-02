import 'package:http/http.dart' as http;

class HTTPService {
  Future<http.Response> fetchCSV() async {
    int startTimestamp = 0;
    // DateTime(2023, 10, 1, 0, 0).millisecondsSinceEpoch ~/1000; // DateTime(2017, 9, 7, 17, 30); 7th of September 2017, 5:30pm
    int endTimestamp =
        // 1696108581;
        1699690757;
    // DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final url = Uri.parse(
        'https://query1.finance.yahoo.com/v7/finance/download/SPY?period1=$startTimestamp&period2=$endTimestamp&interval=1d&events=history&includeAdjustedClose=true');
    /* 
    Possible inputs for &interval=: 1m, 5m, 15m, 30m, 90m, 1h, 1d, 5d, 1wk, 1mo, 3mo
    
    m (minute) intervals are limited to 30days with period1 and period2 spaning a maximum of 7 days per/request. Exceeding either of these limits will result in an error and will not round
    
    h (hour) interval is limited to 730days with no limit to span. Exceeding this will result in an error and will not round
    */

    // Modify the request headers to accept CSV data
    final headers = {'Accept': 'text/csv'};

    // Send the HTTP GET request with the updated URL and headers
    return http.get(url, headers: headers);
  }

  Future<http.Response> fetchJSON(String dateFrom, String dateTo) async {
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
}
