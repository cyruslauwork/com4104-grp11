import 'package:flutter/material.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/views/charts/charts.dart';

class TrendMatchView extends StatelessWidget {
  // const TrendMatchView({super.key});

  // Singleton implementation
  static TrendMatchView? _instance;
  factory TrendMatchView({Key? key}) {
    _instance ??= TrendMatchView._(key: key);
    return _instance!;
  }
  const TrendMatchView._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPresenter.to.showTm();
  }

  Widget showAdjustedLineChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected trend with matched historical trends',
          style: const TextTheme().sp5,
        ),
        Text(
          '(adjusted last prices to be the same as the last selected price and apply to previous prices)',
          style: const TextTheme().sp4,
        ),
        Text(
          'and their subsequent trends',
          style: const TextTheme().sp5,
        ),
        Text(
          '(adjusted first prices to be the same as the last selected price and apply to subsequent prices)',
          style: const TextTheme().sp4,
        ),
        AdjustedLineChart()
      ],
    );
  }

  Widget showCircularProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: const CircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text('Trend matching...', style: const TextTheme().sp5),
        ),
      ],
    );
  }
}
