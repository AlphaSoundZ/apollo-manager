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
    required this.fabLabel,
    required this.fabIcon,
  });
  final IconData icon;
  final String label;
  final String route;
  final dynamic view;
  final String fabLabel;
  final IconData fabIcon;
}

class Destinations {
  late List<Destination> destinations = <Destination>[
    Destination(
      icon: Icons.data_array,
      label: 'Data',
      route: '/data',
      subDestinations: [
        SubDestination(
          icon: Icons.group_outlined,
          label: 'Users',
          route: '/data/users',
          view: const DataView(),
          fabLabel: 'User',
          fabIcon: Icons.person_add_outlined,
        ),
        SubDestination(
          icon: Icons.devices_outlined,
          label: 'Devices',
          route: '/data/devices',
          view: const Center(child: Text('Devices')),
          fabLabel: 'Device',
          fabIcon: Icons.devices_outlined,
        ),
        SubDestination(
          icon: Icons.class_outlined,
          label: 'Classes',
          route: '/data/classes',
          view: const Center(child: Text('Classes')),
          fabLabel: 'Class',
          fabIcon: Icons.class_outlined,
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
