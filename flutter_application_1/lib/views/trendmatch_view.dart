import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/views/charts/charts.dart';

class TrendMatchView extends StatelessWidget {
  // const TrendMatchView({super.key});

  // Singleton implementation
  static final TrendMatchView _instance = TrendMatchView._internal();
  factory TrendMatchView() {
    return _instance;
  }
  TrendMatchView._internal();

  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainPresenter.to.showStartBtn(),
        Center(child: MainPresenter.to.showTm()),
      ],
    );
  }

  Widget showAdjustedLineChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Tooltip(
                key: tooltipkey,
                triggerMode: TooltipTriggerMode.manual,
                message:
                    '1) We adjusted last prices to be the same as the last selected price and apply to previous prices. \n2) adjusted first prices to be the same as the last selected price and apply to subsequent prices.',
                child: Text(
                  '${'recent'.tr}${MainPresenter.to.range.toString()}${'tm_title1'.tr}${MainPresenter.to.tolerance.toString()}${'tm_title2'.tr}',
                  style: const TextTheme().sp5.w700,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeColor.primary.value),
                child: IconButton(
                  onPressed: () =>
                      tooltipkey.currentState?.ensureTooltipVisible(),
                  icon: Transform.translate(
                    offset: Offset(0.0, -1.5.h),
                    child: const Icon(
                      Icons.question_mark,
                    ),
                  ),
                  color: AppColor.whiteColor,
                  iconSize: 7.h,
                ),
              ),
            )
          ],
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
          child: Text('trend_matching'.tr, style: const TextTheme().sp5),
        ),
      ],
    );
  }
}
