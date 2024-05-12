import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:get/get.dart';

import 'package:market_ai/models/models.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/utils/utils.dart';

class AdjustedLineChart extends StatelessWidget {
  final LineChartData lineChartData;

  AdjustedLineChart({Key? key, LineChartData? lineChartData})
      : lineChartData =
            lineChartData ?? TrendMatch().getDefaultAdjustedLineChartData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor.withOpacity(0.5), // Set 50% transparency
          ),
          child: Row(
            children: [
              SizedBox(
                width: MainPresenter.to.tmChartWidth.value,
                height: 85.h,
                child: LineChart(lineChartData),
              ),
              MainPresenter.to.sidePlot.value,
            ],
          ),
        ),
      ),
    );
  }
}
