import 'package:flutter/material.dart';
import 'views/data_list_view.dart';
import 'package:get/get.dart';
import 'classes/api.dart';

class Destination {
  const Destination(this.icon, this.label, this.view);
  final IconData icon;
  final String label;
  final Widget view;
}

List<Destination> destinations = <Destination>[
  const Destination(
    Icons.data_array,
    'Data',
    DataListView(),
  ),
  const Destination(
    Icons.search,
    'Search',
    Center(child: Text('Search')),
  ),
  const Destination(
    Icons.calendar_month,
    'Prebook',
    Center(child: Text('Prebook')),
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
