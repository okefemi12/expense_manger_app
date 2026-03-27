import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}

class DashboardSyncfusionChart extends StatelessWidget {
  final List<ChartData> data;

  const DashboardSyncfusionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          labelStyle: TextStyle(color: Colors.white54),
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        primaryYAxis: const NumericAxis(isVisible: false),
        plotAreaBorderWidth: 0,
        series: <CartesianSeries>[
          SplineSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            color: Colors.blueAccent,
            width: 4,
            splineType: SplineType.natural,
          ),
        ],
      ),
    );
  }
}
