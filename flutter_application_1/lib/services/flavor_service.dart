import 'dart:io';
import 'package:get/get.dart';

enum Flavor {
  dev('DEV', 'https://xxx.dev/api/v1/'),
  uat('UAT', 'https://xxx.dev/api/v1/'),
  prod('PROD', 'https://xxx.dev/api/v1/');

  const Flavor(this.name, this.configUrl);

  final String name;
  final String configUrl;

  bool get isDev => this == dev;
  bool get isUat => this == uat;
  bool get isProd => this == prod;
}

class FlavorService extends GetxService {
  // Singleton implementation
  static FlavorService? _instance;
  factory FlavorService() {
    _instance ??= FlavorService._();
    return _instance!;
  }
  FlavorService._();

  static FlavorService get to => Get.find();

  late final Flavor flavor;
  late final APIProvider apiProvider;
  late final SrcFileType srcFileType;
  String version = "";
  String platform = "";
  String uuid = "";
  String fcmToken = "";

  Future<FlavorService> init(Flavor flavor, APIProvider apiProvider) async {
    this.flavor = flavor;
    this.apiProvider = apiProvider;

    if (apiProvider == APIProvider.yahoofinance) {
      srcFileType = SrcFileType.csv;
    } else if (apiProvider == APIProvider.polygon) {
      srcFileType = SrcFileType.json;
    } else {
      throw ArgumentError('Failed to check API provider.');
    }

    platform = Platform.isAndroid ? 'android' : 'ios';
    return this;
  }
}

enum RouteName {
  mainView('/mainview'),
  searchView('/searchview'),
  chatView('/chatview');

  const RouteName(this.path);

  final String path;
}

enum APIProvider {
  yahoofinance,
  polygon;
}

enum SrcFileType {
  csv,
  json;
}

enum Func {
  devMode;
}

enum Question {
  affecting,
  challenges;

  static String getQuestionText(Question question) {
    switch (question) {
      case Question.affecting:
        return 'question1'.tr;
      case Question.challenges:
        return 'question2'.tr;
    }
  }
}
