import 'package:flutter/material.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/views/charts/charts.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Tooltip(
                key: tooltipkey,
                triggerMode: TooltipTriggerMode.manual,
                message:
                    '1) We adjusted last prices to be the same as the last selected price and apply to previous prices. \n2) adjusted first prices to be the same as the last selected price and apply to subsequent prices.',
                child: Text(
                  'Recent ${MainPresenter.to.range.toString()}-day(s) trend with matched historical trend(s) and their subsequent trend(s) (${MainPresenter.to.tolerance.toString()}% tolerance)',
                  style: const TextTheme().sp5.w700,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-5.w, 2.h),
              child: SizedBox(
                height: 10.h,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ThemeColor.primary.value),
                  child: Transform.scale(
                    scale: 0.75,
                    child: Transform.translate(
                      offset: Offset(0.0, -2.h),
                      child: IconButton(
                        onPressed: () =>
                            tooltipkey.currentState?.ensureTooltipVisible(),
                        icon: const Icon(Icons.question_mark),
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
          child: Text('Trend matching...', style: const TextTheme().sp5),
        ),
      ],
    );
  }
}
