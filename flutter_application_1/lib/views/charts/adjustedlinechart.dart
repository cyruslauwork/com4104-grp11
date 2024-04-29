import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/utils/utils.dart';

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
