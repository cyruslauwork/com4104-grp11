import 'package:flutter/material.dart';

import 'package:flutter_application_1/utils/utils.dart';

class AppColor {
  // Singleton implementation
  static final AppColor _instance = AppColor._();
  factory AppColor() => _instance;
  AppColor._();

  static final primaryTextColor = ThemeColor.primary.value;
  // static const secondaryTextColor = Color(0xff000000);
  // static const editTextColor = Color(0xff000000);
  // static const editTextErrorColor = Color(0xff000000);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const greyColor = Color(0xff808080);
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

extension CustomStyles on TextTheme {
  TextStyle get sp3 => TextStyle(
        color: AppColor.primaryTextColor,
        fontSize: 3.sp,
      );
  TextStyle get sp5 => TextStyle(
        color: AppColor.primaryTextColor,
        fontSize: 5.sp,
      );
  TextStyle get sp7 => TextStyle(
        color: AppColor.primaryTextColor,
        fontSize: 7.sp,
      );
  TextStyle get sp10 => TextStyle(
        color: AppColor.primaryTextColor,
        fontSize: 10.sp,
      );
}

extension CustomTextStyle on TextStyle {
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  // TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  // TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  // TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  // TextStyle get secondaryTextColor =>
  //     copyWith(color: AppColor.secondaryTextColor);
  // TextStyle get primaryTextColor => copyWith(color: AppColor.primaryTextColor);
  // TextStyle get primaryTextColor2 =>
  //     copyWith(color: AppColor.primaryTextColor2);
  // TextStyle get blackColor => copyWith(color: AppColor.blackColor);
  // TextStyle get editTextColor => copyWith(color: AppColor.editTextColor);
  // TextStyle get editTextErrorColor =>
  //     copyWith(color: AppColor.editTextErrorColor);
  // TextStyle get greyColor => copyWith(color: AppColor.greyColor);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
}
