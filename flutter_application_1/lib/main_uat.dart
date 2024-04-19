import 'bootstrap.dart';
import 'package:flutter_application_1/services/services.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  bootstrap(Flavor.uat, APIProvider.yahoofinance);
}

class MyHttpOverrides extends HttpOverrides {
  // Singleton implementation
  static final MyHttpOverrides _instance = MyHttpOverrides._internal();
  factory MyHttpOverrides() {
    return _instance;
  }
  MyHttpOverrides._internal();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
