import 'package:flutter/material.dart';

enum Lang {
  en('en_UK', 'en', 'UK'),
  zh('zh_HK', 'zh', 'HK');

  const Lang(this.localeKey, this.langCode, this.countryCode);
  final String localeKey;
  final String langCode;
  final String countryCode;

  static Lang enumerate(String? localeKey) {
    return values.firstWhere((e) => e.localeKey == localeKey, orElse: () => en);
  }

  bool get isZH => this == zh;
  bool get isEN => this == en;

  Locale get locale => Locale(langCode, countryCode);
}
