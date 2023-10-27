import 'package:http/http.dart' as http;

class HTTPService {
  Future<http.Response> fetchCSV() async {
    var timestampStart = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var timestampEnd = DateTime(2023, 10, 1, 0, 0).millisecondsSinceEpoch ~/
        1000; // DateTime(2017, 9, 7, 17, 30); 7th of September 2017, 5:30pm
    // Update the URL to point to the CSV file
    final url = Uri.parse(
        'https://query1.finance.yahoo.com/v7/finance/download/SPY?period1=$timestampEnd&period2=$timestampStart&interval=1d&events=history&includeAdjustedClose=true');

    // Modify the request headers to accept CSV data
    final headers = {'Accept': 'text/csv'};

    // Send the HTTP GET request with the updated URL and headers
    return http.get(url, headers: headers);
  }
}
