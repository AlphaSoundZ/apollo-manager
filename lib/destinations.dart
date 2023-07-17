import 'package:flutter/material.dart';
import 'views/data_list_view.dart';
import 'package:get/get.dart';
import 'classes/api.dart';

/// [view] should be either a [Widget] or a [StatefulBuilder], use [StatefulBuilder] if you need to use [setState] inside the view.
class Destination {
  Destination(this.icon, this.label, this.view);
  final IconData icon;
  final String label;
  final dynamic view;
}

class Destinations {
  int selectedIndex = 0;
  late List<Destination> destinations = <Destination>[
    Destination(
      Icons.data_array,
      'Data',
      StatefulBuilder(
        builder: (BuildContext context, setState) {
          return DataListView(
            selectedIndex: selectedIndex,
            onSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          );
        },
      ),
    ),
    Destination(
      Icons.search,
      'Search',
      const Center(child: Text('Search')),
    ),
    Destination(
      Icons.calendar_month,
      'Prebook',
      const Center(child: Text('Prebook')),
    ),
    Destination(
      Icons.bar_chart,
      'Stats',
      const Center(
        child: Center(
          child: Text('Stats'),
        ),
      ),
    ),
    Destination(
      Icons.settings,
      'Settings',
      Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  Api api = Api();
                  api.logout();
                  Get.offAllNamed("/login");
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}
