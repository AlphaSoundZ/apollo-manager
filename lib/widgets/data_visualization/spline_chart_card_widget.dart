import 'package:apollo_manager/widgets/data_visualization/dual_tone_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/coordinate_model.dart';

class SplineChartCard extends StatefulWidget {
  const SplineChartCard(
      {super.key,
      required this.data,
      required this.title,
      required this.subTitle,
      required this.max});

  final List<Coordinate> data;
  final String title;
  final String subTitle;
  final double max;

  @override
  State<SplineChartCard> createState() => _SplineChartCardState();
}

class _SplineChartCardState extends State<SplineChartCard> {
  @override
  Widget build(BuildContext context) {
    return DualToneCard(
      content: SfCartesianChart(
        // hide grid lines
        primaryXAxis: CategoryAxis(isVisible: false),
        primaryYAxis:
            NumericAxis(isVisible: false, maximum: widget.max + 2, minimum: -2),

        // hide border
        plotAreaBorderWidth: 0,

        // example series with raw data
        series: <SplineSeries<Coordinate, int>>[
          SplineSeries<Coordinate, int>(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            dataSource: widget.data,
            splineType: SplineType.clamped,
            xValueMapper: (Coordinate data, _) => data.x,
            yValueMapper: (Coordinate data, _) => data.y,
          ),
        ],
      ),
      title: widget.title,
      subTitle: widget.subTitle,
    );
  }
}
