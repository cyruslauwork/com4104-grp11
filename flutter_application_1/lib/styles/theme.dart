import 'package:flutter/material.dart';

class AppColor {
  // Singleton implementation
  static final AppColor _instance = AppColor._();
  factory AppColor() => _instance;
  AppColor._();

  static const primaryTextColor = Colors.black;
  // static const secondaryTextColor = Color(0xff000000);
  // static const editTextColor = Color(0xff000000);
  // static const editTextErrorColor = Color(0xff000000);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const greyColor = Color(0xff909090);
  // static const backgroundColor = Color(0xff000000);
  static const errorColor = Colors.red;
  // static const imageDefaultBgColor = Color(0xff000000);
  // static const transparentColor = Colors.transparent;
  // static const borderColor = Color(0xff000000);
}

enum ThemeColor { primary, secondary, tertiary }

extension ThemeColorExtension on ThemeColor {
  Color get value {
    switch (this) {
      case ThemeColor.primary:
        return Colors.red;
      case ThemeColor.secondary:
        return Colors.blue;
      case ThemeColor.tertiary:
        return Colors.yellow;
    }
  }
}
