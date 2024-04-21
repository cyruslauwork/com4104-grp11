import 'package:intl/intl.dart';
import 'package:get/get.dart';

class TimeService extends GetxService {
  // Singleton implementation
  static final TimeService _instance = TimeService._();
  factory TimeService() => _instance;
  TimeService._();

  static TimeService get to => Get.find();

  Future<TimeService> init() async {
    return this;
  }

  int convertToUnixTimestamp(String dateString) {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final DateTime date = format.parse(dateString);
    final int timestamp = date.millisecondsSinceEpoch ~/ 1000;
    return timestamp;
  }

  bool isEasternDaylightTime(DateTime dateTime) {
    int year = dateTime.year;
    DateTime startDst =
        DateTime.utc(year, 3, (14 - (5 * year ~/ 4 + 1) % 7), 2);
    DateTime endDst = DateTime.utc(year, 11, (7 - (5 * year ~/ 4 + 1) % 7), 2);
    return dateTime.isAfter(startDst) && dateTime.isBefore(endDst);
  }

  bool isEasternStandardTime(DateTime dateTime) {
    return !isEasternDaylightTime(dateTime);
  }
}
