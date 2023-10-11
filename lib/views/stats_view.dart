import 'dart:math';

import 'package:apollo_manager/enums/which_data.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/coordinate_model.dart';
import '../models/data_model.dart';
import '../models/user_model.dart';
import '../services/api.dart';
import '../widgets/data_visualization/number_card_widget.dart';
import '../widgets/data_visualization/spline_chart_card_widget.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();
  User? user;
  dynamic amountOfAvailableDevices;

  @override
  void initState() {
    _storage.getString('userId').then((userId) {
      setState(() {
        user = Provider.of<DataModel>(context, listen: false)
            .getById(context, WhichData.users, int.parse(userId));
      });
    });

    // get amount of available devices
    Api().get(context, route: "/booking/available").then((responseBody) {
      setState(() {
        amountOfAvailableDevices = responseBody.data[0]["amount"];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              children: [
                if (amountOfAvailableDevices != null) ...[
                  NumberCard(
                    number: "$amountOfAvailableDevices",
                    title: "Amount",
                    subTitle: "Available devices",
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
                ],
                if (user != null && !user!.multiBooking)
                  NumberCard(
                    number: Random().nextBool() ? "Yes" : "No",
                    title: "Booking",
                    subTitle: "Current booking activity",
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
