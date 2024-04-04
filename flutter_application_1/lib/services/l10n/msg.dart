import 'package:get/get.dart';

class Msg extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_UK': {
          'app_name': 'Stock Insight',
          'candle_chart': 'Max 1000-Row Candlestick Chart',
        },
        'zh_HK': {
          'app_name': '股票慧眼',
          'candle_chart': '最大 1000 行陰陽燭圖',
        },
      };
}
