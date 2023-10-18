import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService extends GetxService {
  static PrefsService get to => Get.find();

  late final SharedPreferences prefs;

  Future<PrefsService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }
}
