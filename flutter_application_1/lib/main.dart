import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'services/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  bootstrap(Flavor.prod);
}
