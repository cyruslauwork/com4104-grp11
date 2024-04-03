import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import './services/services.dart';
import './views/views.dart';
import './presenters/presenters.dart';
import './styles/style.dart';

var logger = Logger();

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRoot> with WidgetsBindingObserver {
  // Size currentScreenSize =
  //     Size(ScreenUtils().screenWidth, ScreenUtils().screenHeight);

  @override
  void initState() {
    super.initState();
    Get.put(MainPresenter());

    // WidgetsBinding.instance.addObserver(this);
    //...
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      logger.d("resumed: $state");
      MainPresenter.to.reload;
    }
  }

  //this method only use for special issue
  // void _rebuildAllChildren(BuildContext context) {
  //   void rebuild(Element el) {
  //     el.markNeedsBuild();
  //     el.visitChildren(rebuild);
  //   }

  //   (context as Element).visitChildren(rebuild);
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // builder: (BuildContext context, Widget? child) {
        //   final MediaQueryData data = MediaQuery.of(context);
        //   // Rebuild the screen to fix mobile setting horizontal screen issue
        //   if (currentScreenSize != data.size) {
        //     Future.delayed(const Duration(seconds: 0), () {
        //       _rebuildAllChildren(context);
        //       logger.d(
        //           'update MediaQueryData width: ${data.size.width}, height: ${data.size.height}');
        //     });
        //     currentScreenSize = data.size;
        //   }
        //   return MediaQuery(
        //     data: data.copyWith(
        //         textScaleFactor:
        //             data.textScaleFactor > ScreenUtils().maxTextScaleFactor
        //                 ? ScreenUtils().maxTextScaleFactor
        //                 : data.textScaleFactor),
        //     child: child!,
        //   );
        // },
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeColor.primary.value,
            secondary: ThemeColor.secondary.value,
            tertiary: ThemeColor.tertiary.value,
            brightness: MainPresenter.to.darkMode.value
                ? Brightness.dark
                : Brightness.light,
          ),
        ),
        initialRoute: RouteName.mainScreen.path,
        getPages: [
          // GetPage(
          //     name: RouteName.pageNotFound.path,
          //     page: () => const PageNotFoundScreen()),
          GetPage(
              name: RouteName.mainScreen.path, page: () => const MainView()),
          // GetPage(
          //   name: RouteName.mainScreen.path,
          //   page: () => const MainScreen(),
          //   binding: BindingsBuilder(() {
          //     Get.put(HomeScreenController());
          //     Get.put(Screen2Controller());
          //     Get.put(Screen3Controller());
          //     Get.put(Screen4Controller());
          //   }),
          // ),
          // GetPage(
          //   name: RouteName.settingScreen.path,
          //   page: () => const SettingsScreen(),
          //   binding: BindingsBuilder(() {
          //     Get.put(SettingsScreenController());
          //   }),
          // ),
          // if (kDebugMode)
          //   GetPage(
          //     name: RouteName.testApiScreen.path,
          //     page: () => const TestApiScreen(),
          //     binding: BindingsBuilder(() {
          //       Get.put(TestApiScreenController());
          //     }),
          //   ),
        ],
      ),
    );
  }
}
