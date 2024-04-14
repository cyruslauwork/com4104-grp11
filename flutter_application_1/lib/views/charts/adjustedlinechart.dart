import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/utils/utils.dart';

class AdjustedLineChart extends StatelessWidget {
  final LineChartData lineChartData;

  AdjustedLineChart({Key? key, LineChartData? lineChartData})
      : lineChartData =
            lineChartData ?? TrendMatch().getDefaultAdjustedLineChartData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393.w,
      height: 100.h,
      child: LineChart(lineChartData),
    );
  }
}
