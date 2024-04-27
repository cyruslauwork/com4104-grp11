import 'package:get/get.dart';

class Msg extends Translations {
  // Singleton implementation
  static final Msg _instance = Msg._internal();
  factory Msg() {
    return _instance;
  }
  Msg._internal();

  @override
  Map<String, Map<String, String>> get keys => {
        'en_UK': {
          'app_name': 'Market.AI📈',
          'candle_chart_title': 'Max 1000-Row Candlestick Chart',
          'as_of': 'As of',
          'mkt_data': 'Market data provided by',
          'trend_matching': 'Trend matching...',
          'btn_tm_sa': 'Historical trend matching and analytics',
          'downloading_candle': 'Downloading candlestick data...',
          'power_from': 'Computing power comes from',
          'recent': 'Recent ',
          'tm_title1':
              '-day(s) trend with matched historical trend(s) and their subsequent trend(s) (',
          'tm_title2': '% tolerance)',
          'sub_analyzing': 'Awaiting subsequent trend analytics results...',
          'notice': 'Notice!',
          'too_many_matches':
              'Too many matches. It is recommended to select the financial instrument from the drop-down list.',
          'no_match_found':
              'No match was found. It is recommended to select the financial instrument from the drop-down list.',
          'no_input':
              'A financial instrument should be selected before the submission.',
          'search': 'Search 🔍',
          'tolerance': 'Trend Match Tolerance',
          'date_range': 'Date Range',
          '2days': '2 Days',
          '20days': '20 Days',
          'input_placeholder': "Type what you're interested in 😊",
          'reset': 'Reset',
          'submit': 'Submit',
          'listings': 'Latest stock listings on',
          'news_ai_title': 'Chat with News AI',
          'power_by': 'Powered by',
          'input_placeholder2': "Type and select your interest 😊",
          'system_info': 'System Info',
          'dev_mode': 'Developer mode is on',
          'question1':
              'Are there any recent news that may affecting the prices of stocks or ETFs in my watchlist?',
          'question2':
              'What are the major challenges facing the stocks or ETFs in my watchlist?',
          'question1_trimmed':
              'Are there any recent news that may affecting the prices of ',
          'question2_trimmed': 'What are the major challenges facing the ',
        },
        'zh_HK': {
          'app_name': '市場慧眼📈',
          'candle_chart_title': '最大 1000 行陰陽燭圖',
          'as_of': '截至',
          'mkt_data': '市場數據提供者',
          'trend_matching': '走勢匹配中...',
          'btn_tm_sa': '歷史走勢匹配和分析',
          'downloading_candle': '正在下載陰陽燭數據...',
          'power_from': '運算能力來自於',
          'recent': '最近',
          'tm_title1': '日走勢與相似歷史走勢及其後續走勢 (',
          'tm_title2': '%容差)',
          'sub_analyzing': '等待後續走勢分析結果...',
          'notice': '注意!',
          'too_many_matches': '過多匹配。建議從下拉清單中選擇金融工具。',
          'no_match_found': '找不到匹配。建議從下拉清單中選擇金融工具。',
          'no_input': '提交前應選擇金融工具。',
          'search': '搜尋 🔍',
          'tolerance': '走勢匹配容差',
          'date_range': '日數範圍',
          '2days': '2日',
          '20days': '20日',
          'input_placeholder': "輸入您有興趣的內容😊",
          'reset': '重設',
          'submit': '提交',
          'listings': '最新股票列表來自',
          'news_ai_title': '與新聞 AI 聊天',
          'power_by': '提供自',
          'input_placeholder2': "輸入並選擇您的興趣😊",
          'system_info': '系統資訊',
          'dev_mode': '開發者模式已開啟',
          'question1': '最近是否有任何可能影響我的觀察清單中的股票或 ETF 價格的新聞？',
          'question2': '我的觀察名單中的股票或 ETF 面臨哪些主要挑戰？',
          'question1_trimmed': '近期消息中是否有可能影響價格於',
          'question2_trimmed': '有什麼主要面臨的挑戰於',
        },
      };
}
