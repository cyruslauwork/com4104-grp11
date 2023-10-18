import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'services/services.dart';
import 'app_root.dart';
import 'controllers/controllers.dart';
import 'package:logger/logger.dart';

var logger = Logger();

Future<void> bootstrap(Flavor flavor) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await initServices(flavor);
    await addGlobalController(flavor);

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

Future<void> initServices(Flavor flavor) async {
  logger.d('starting services ...');

  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await Get.putAsync(() => PrefsService().init());
  await Get.putAsync(() => FlavorService().init(flavor));
}

Future<void> addGlobalController(Flavor flavor) async {
  Get.put(GlobalController());
}
