import 'package:get/get.dart';
import 'package:flutter_application_1/services/l10n/lang.dart';
export 'package:flutter_application_1/services/l10n/lang.dart';
export 'package:flutter_application_1/services/l10n/msg.dart';
import 'package:flutter_application_1/services/prefs/prefs_service.dart';

class LangService extends GetxService {
  // Singleton implementation
  static final LangService _instance = LangService._();
  factory LangService() => _instance;
  LangService._();

  static LangService get to => Get.find();

  late Lang currentLang;

  Future<LangService> init() async {
    String? saveLang = PrefsService.to.prefs
        .getString(SharedPreferencesConstant.saveLanguageKey);
    if (saveLang == null) {
      // The language has not been saved before.
      currentLang = Lang.en;
    } else {
      // The language has been saved before.
      currentLang = Lang.enumerate(saveLang);
    }

    Get.updateLocale(currentLang.locale);

    return this;
  }

  void changeLanguage(Lang lang) {
    currentLang = lang;

    PrefsService.to.prefs
        .setString(SharedPreferencesConstant.saveLanguageKey, lang.localeKey);

    Get.updateLocale(lang.locale);
  }
}
