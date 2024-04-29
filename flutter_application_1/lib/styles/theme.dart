import 'package:flutter/material.dart';

class AppColor {
  // Singleton implementation
  static final AppColor _instance = AppColor._();
  factory AppColor() => _instance;
  AppColor._();

  static var primaryTextColor = Colors.black;
  // static var secondaryTextColor = Color(0xff000000);
  // static var editTextColor = Color(0xff000000);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const greyColor = Color(0xff909090);
  // static const backgroundColor = Color(0xff000000);
  static const errorColor = Colors.red;
  static const imageDefaultBgColor = Color(0xffffffff);
  // static const transparentColor = Colors.transparent;
  // static const borderColor = Color(0xff000000);
}

enum ThemeColor { primary, secondary, tertiary }

extension ThemeColorExtension on ThemeColor {
  Color get value {
    switch (this) {
      case ThemeColor.primary:
        return const Color(0xfff44336);
      case ThemeColor.secondary:
        return const Color(0xffB71C1C);
      case ThemeColor.tertiary:
        return const Color(0xffff9800);
    }
  }
}
