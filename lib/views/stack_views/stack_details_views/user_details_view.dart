import 'dart:math';

import 'package:apollo_manager/models/stack_view_model.dart';
import 'package:apollo_manager/widgets/data_visualization/number_card_widget.dart';
import 'package:apollo_manager/widgets/data_visualization/spline_chart_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../enums/which_data.dart';
import '../../../models/coordinate_model.dart';
import '../../../models/data_model.dart';

StackViewModel userDetailsStackView(BuildContext context,
    {required int id, required WhichData whichData}) {
  dynamic user = Provider.of<DataModel>(context, listen: true).getById(
    whichData,
    id,
  );

  return StackViewModel(
    title: user.name.fullName,
    subTitle: user.className,
    content: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              children: [
                SplineChartCard(
                  data: [
                    Coordinate(0, Random().nextInt(10)),
                    Coordinate(1, Random().nextInt(10)),
                    Coordinate(2, Random().nextInt(10)),
                    Coordinate(3, Random().nextInt(10)),
                    Coordinate(4, Random().nextInt(10)),
                    Coordinate(5, Random().nextInt(10)),
                    Coordinate(6, Random().nextInt(10)),
                    Coordinate(7, Random().nextInt(10)),
                    Coordinate(8, Random().nextInt(10)),
                    Coordinate(9, Random().nextInt(10)),
                    Coordinate(10, Random().nextInt(10)),
                    Coordinate(11, Random().nextInt(10)),
                    Coordinate(12, Random().nextInt(10)),
                    Coordinate(13, Random().nextInt(10)),
                    Coordinate(14, Random().nextInt(10)),
                  ],
                  title: "Activity",
                  subTitle: "Last two weeks",
                  max: 10,
                ),
                const NumberCard(
                  number: "10/15",
                  title: "Amount",
                  subTitle: "Devices currently in use",
                ),
                SplineChartCard(
                  data: [
                    Coordinate(0, Random().nextInt(5) + 10),
                    Coordinate(1, Random().nextInt(5) + 10),
                    Coordinate(2, Random().nextInt(5) + 10),
                    Coordinate(3, Random().nextInt(5) + 10),
                    Coordinate(4, Random().nextInt(5) + 10),
                    Coordinate(5, Random().nextInt(5) + 10),
                    Coordinate(6, Random().nextInt(5) + 10),
                    Coordinate(7, Random().nextInt(5) + 10),
                    Coordinate(8, Random().nextInt(5) + 10),
                    Coordinate(9, Random().nextInt(5) + 10),
                    Coordinate(10, Random().nextInt(5) + 10),
                    Coordinate(11, Random().nextInt(5) + 10),
                    Coordinate(12, Random().nextInt(5) + 10),
                    Coordinate(13, Random().nextInt(5) + 10),
                    Coordinate(14, Random().nextInt(5) + 10),
                  ],
                  max: 15,
                  title: "Average Amount",
                  subTitle: "Last two weeks",
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
