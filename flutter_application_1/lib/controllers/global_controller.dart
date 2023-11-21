import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.put(GlobalController());

  void reload() {
    Get.delete<GlobalController>();
    Get.put(GlobalController());
    super.onInit();
  }

  RxBool darkMode = true.obs;
  RxBool showAverage = true.obs;

  RxInt downloadTime = 0.obs;
  RxList<CandleData> listCandleData = [
    CandleData(timestamp: 0000000000 * 1000, open: 0, close: 0, volume: 0)
  ].obs;

  RxList<double> selectedPeriodList = [0.0].obs;
  RxList<List<double>> comparePeriodList = [
    [0.0]
  ].obs;
  RxList<List<double>> matchListList = [
    [0.0]
  ].obs;
  RxList<int> trendMatchOutput = [0, 0, 0, 0, 0].obs;

  RxInt elapsedTime = 0.obs;
  Rx<DateTime> lastJsonEndDate = DateTime(2023).obs;
  List<Map<String, dynamic>> lastJson = [];
  RxInt lastCandleDataLength = 0.obs;
}
