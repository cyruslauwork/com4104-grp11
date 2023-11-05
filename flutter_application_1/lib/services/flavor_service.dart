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
  static FlavorService get to => Get.find();

  late final Flavor flavor;
  String version = "";
  String platform = "";
  String uuid = "";
  String fcmToken = "";

  Future<FlavorService> init(Flavor flavor) async {
    this.flavor = flavor;
    platform = Platform.isAndroid ? 'android' : 'ios';
    return this;
  }
}

enum RouteName {
  mainScreen('/mainscreen');

  const RouteName(this.path);

  final String path;
}
