import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class TimeService {
  int convertToUnixTimestamp(String dateString) {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final DateTime date = format.parse(dateString);
    final int timestamp = date.millisecondsSinceEpoch ~/ 1000;
    // logger.d(timestamp);
    return timestamp;
  }
}
