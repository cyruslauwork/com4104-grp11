import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import './services/services.dart';
import 'app_root.dart';

var logger = Logger();

Future<void> bootstrap(Flavor flavor, APIProvider apiProvider) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initServices(flavor, apiProvider);

    /*
      Preferred device orientation(s)
    */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(const AppRoot());
  }, (error, stackTrace) {});
}

Future<void> initServices(Flavor flavor, APIProvider apiProvider) async {
  logger.d('Starting services ...');

  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or drift connection, or whatever that's async.
  await Get.putAsync(() => PrefsService().init());
  await Get.putAsync(() => FlavorService().init(flavor, apiProvider));
}
