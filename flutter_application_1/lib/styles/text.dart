import 'package:flutter/material.dart';

import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';

extension CustomStyles on TextTheme {
  TextStyle get sp4 => TextStyle(
        color: ThemeColor.primary.value,
        fontSize: 4.sp,
        fontFamily: font,
      );
  TextStyle get sp5 => TextStyle(
        color: ThemeColor.primary.value,
        fontSize: 5.sp,
        fontFamily: font,
      );
  TextStyle get sp7 => TextStyle(
        color: ThemeColor.primary.value,
        fontSize: 7.sp,
        fontFamily: font,
      );
  TextStyle get sp10 => TextStyle(
        color: ThemeColor.primary.value,
        fontSize: 10.sp,
        fontFamily: font,
      );

  String get font {
    switch (LangService.to.currentLang) {
      case Lang.en:
        return 'OpenSans';
      case Lang.zh:
        return 'NotoSansHK';
    }
  }
}

extension CustomTextStyle on TextStyle {
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  // TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  // TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  // TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get primaryTextColor => copyWith(color: AppColor.primaryTextColor);
  // TextStyle get secondaryTextColor =>
  //     copyWith(color: AppColor.secondaryTextColor);
  // TextStyle get blackColor => copyWith(color: AppColor.blackColor);
  // TextStyle get editTextColor => copyWith(color: AppColor.editTextColor);
  // TextStyle get editTextErrorColor =>
  //     copyWith(color: AppColor.editTextErrorColor);
  TextStyle get greyColor => copyWith(color: AppColor.greyColor);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get themeTextColor => copyWith(color: ThemeColor.primary.value);
}
