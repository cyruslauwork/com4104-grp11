import 'package:intl/intl.dart';

class TimeService {
  // Singleton implementation
  static final TimeService _instance = TimeService._();
  factory TimeService() => _instance;
  TimeService._();

  int convertToUnixTimestamp(String dateString) {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final DateTime date = format.parse(dateString);
    final int timestamp = date.millisecondsSinceEpoch ~/ 1000;
    return timestamp;
  }
}
