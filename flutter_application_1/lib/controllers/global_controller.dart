import 'package:get/get.dart';

class GlobalController extends GetxController {
  static GlobalController get to => GlobalController();

  void reload() {
    Get.delete<GlobalController>();
    Get.put(GlobalController());
    super.onInit();
  }

  var csvDownloadTime = 0.obs;
}
