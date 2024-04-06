import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_application_1/services/prefs/prefs_const.dart';

class PrefsService extends GetxService {
  // Singleton implementation
  static PrefsService? _instance;
  factory PrefsService() {
    _instance ??= PrefsService._();
    return _instance!;
  }
  PrefsService._();

  static PrefsService get to => Get.find();

  late final SharedPreferences prefs;

  Future<PrefsService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }
}
