import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* copy from ScreenUtil lib
* https://pub.dev/packages/flutter_screenutil
* */
class ScreenUtils {
  // iPhone 14 Pro Max Size
  static const Size defaultSize = Size(430, 932);
  static final ScreenUtils _instance = ScreenUtils._();
  static const double _defaultMaxTextScaleFactor = 1.5;
  ScreenUtils._();
  factory ScreenUtils() {
    return _instance;
  }
  double get textScaleFactor => Get.textScaleFactor;
  double get extraTextScaleFactor =>
      min((_maxTextScaleFactor - 1), max(0, textScaleFactor - 1));
  // ignore: deprecated_member_use
  double get screenWidth => WidgetsBinding.instance.window.physicalSize.width;
  // ignore: deprecated_member_use
  double get screenHeight => WidgetsBinding.instance.window.physicalSize.height;

  ///The ratio of actual height to UI design
  double get scaleHeight => screenHeight / _uiSize.height;
  double get scaleWidth => screenWidth / _uiSize.width;
  double get maxTextScaleFactor => _maxTextScaleFactor;

  /// Size of the phone in UI Design , dp
  Size _uiSize = defaultSize;
  double _maxTextScaleFactor = _defaultMaxTextScaleFactor;
  void changeMaxTextScaleFactor(double maxTextScaleFactor) {
    _maxTextScaleFactor = maxTextScaleFactor < 1 ? 1 : maxTextScaleFactor;
  }

  void changeUiSize(Size size) {
    _uiSize = size;
  }

  double get scaleText => scaleWidth;

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  double setWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  double setHeight(num height) => height * scaleHeight;

  ///Adapt according to the smaller of width or height
  double radius(num r) => r * min(scaleWidth, scaleHeight);

  ///Font size adaptation method
  ///- [fontSize] The size of the font on the UI design, in dp.
  double setSp(num fontSize) => fontSize * scaleText;
}

extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => ScreenUtils().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => ScreenUtils().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => ScreenUtils().radius(this);

  ///[ScreenUtil.setSp]
  double get sp => ScreenUtils().setSp(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get sm => min(toDouble(), sp);

  ///Multiple of screen width
  double get sw => ScreenUtils().screenWidth * this;

  ///Multiple of screen height
  double get sh => ScreenUtils().screenHeight * this;
}
