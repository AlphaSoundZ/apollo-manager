import 'package:flutter/material.dart';
import 'views/data_view.dart';
import 'package:get/get.dart';
import 'classes/api.dart';

/// [view] should be either a [Widget] or a [StatefulBuilder], use [StatefulBuilder] if you need to use [setState] inside the view
class Destination {
  Destination({
    this.subDestinations = const [],
    required this.icon,
    required this.label,
    required this.route,
    this.view,
  });
  final IconData icon;
  final String label;
  final String route;
  final dynamic view;
  final List<SubDestination> subDestinations;
}

class SubDestination {
  SubDestination({
    required this.icon,
    required this.label,
    required this.route,
    required this.view,
  });
  final IconData icon;
  final String label;
  final String route;
  final dynamic view;
}

class Destinations {
  late List<Destination> destinations = <Destination>[
    Destination(
      icon: Icons.data_array,
      label: 'Data',
      route: '/data',
      subDestinations: [
        SubDestination(
          icon: Icons.data_array,
          label: 'Users',
          route: '/data/users',
          view: const DataView(),
        ),
        SubDestination(
          icon: Icons.data_array,
          label: 'Devices',
          route: '/data/devices',
          view: const Center(child: Text('Devices')),
        ),
        SubDestination(
          icon: Icons.data_array,
          label: 'Classes',
          route: '/data/classes',
          view: const Center(child: Text('Classes')),
        ),
      ],
    ),
    Destination(
      icon: Icons.search,
      label: 'Search',
      route: '/search',
      view: const Center(child: Text('Search')),
    ),
    Destination(
      icon: Icons.calendar_month,
      label: 'Prebook',
      route: '/prebook',
      view: const Center(child: Text('Prebook')),
    ),
    Destination(
      icon: Icons.bar_chart,
      label: 'Stats',
      route: '/stats',
      view: const Center(
        child: Center(
          child: Text('Stats'),
        ),
      ),
    ),
    Destination(
      icon: Icons.settings,
      label: 'Settings',
      route: '/settings',
      view: Center(
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
