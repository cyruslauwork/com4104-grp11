import 'bootstrap.dart';
import './services/services.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  bootstrap(Flavor.uat, APIProvider.yahoofinance);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
