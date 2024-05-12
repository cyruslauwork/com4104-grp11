import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:market_ai/models/models.dart';
import 'package:market_ai/utils/utils.dart';

class SimpleLineChart extends StatelessWidget {
  final LineChartData lineChartData;
  final bool normalized;

  SimpleLineChart({Key? key, LineChartData? lineChartData, bool? normalized})
      : lineChartData = lineChartData ??
            TrendMatch().getDefaultSimpleLineChartData(normalized ?? false),
        normalized = normalized ?? false,
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
