class SharedPreferencesConstant {
  // Singleton implementation
  static const SharedPreferencesConstant _instance =
      SharedPreferencesConstant._internal();
  factory SharedPreferencesConstant() {
    return _instance;
  }
  const SharedPreferencesConstant._internal();

  static String saveLanguageKey = 'lang';
  static String financialInstrumentSymbol = 'financialInstrumentSymbol';
  static String financialInstrumentName = 'financialInstrumentName';
  static String range = 'range';
  static String tolerance = 'tolerance';
  static String darkMode = 'darkMode';
  static String isEn = 'isEn';
  static String alwaysShowAnalytics = 'alwaysShowAnalytics';
  static String messages = 'messages';
}
