import 'package:apollo_manager/views/prebook_view.dart';
import 'package:flutter/material.dart';
import 'views/data_view.dart';
import 'package:get/get.dart';
import 'classes/api.dart';
import '../enums/which_data.dart';
import '../views/action_views/create_user_view.dart';
import '../views/action_views/create_device_view.dart';

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
    required this.icons,
    required this.label,
    required this.route,
    required this.view,
    required this.whichData,
    required this.fabLabel,
    required this.fabIcon,
    this.fabContent,
  });
  final IconData icons;
  final String label;
  final String route;
  final dynamic view;
  final WhichData whichData;
  final String fabLabel;
  final IconData fabIcon;
  final Widget? fabContent;
}

class Destinations {
  Destinations({this.onFabCancel, this.onFabSubmit});

  final void Function()? onFabCancel;
  final void Function()? onFabSubmit;

  late List<Destination> destinations = <Destination>[
    Destination(
      icon: Icons.data_array,
      label: 'Data',
      route: '/data',
      subDestinations: [
        SubDestination(
          icons: Icons.group_outlined,
          label: 'Users',
          route: '/data/users',
          view: const DataView(
            whichData: WhichData.users,
          ),
          whichData: WhichData.users,
          fabLabel: 'User',
          fabIcon: Icons.person_add_outlined,
          fabContent: CreateUserViewContent(
            onCancel: onFabCancel,
            onSubmit: onFabSubmit,
          ),
        ),
        SubDestination(
          icons: Icons.credit_card_outlined,
          label: 'Usercards',
          route: '/data/usercards',
          view: const DataView(
            whichData: WhichData.usercards,
          ),
          whichData: WhichData.usercards,
          fabLabel: 'Usercard',
          fabIcon: Icons.credit_card_outlined,
        ),
        SubDestination(
          icons: Icons.devices_outlined,
          label: 'Devices',
          route: '/data/devices',
          view: const DataView(
            whichData: WhichData.devices,
          ),
          whichData: WhichData.devices,
          fabLabel: 'Device',
          fabIcon: Icons.devices_outlined,
          fabContent: CreateDeviceViewContent(
            onCancel: onFabCancel,
            onSubmit: onFabSubmit,
          ),
        ),
        SubDestination(
          icons: Icons.token_outlined,
          label: 'Token',
          route: '/data/token',
          view: const DataView(
            whichData: WhichData.tokens,
          ),
          whichData: WhichData.tokens,
          fabLabel: 'Token',
          fabIcon: Icons.token_outlined,
        ),
        SubDestination(
          icons: Icons.class_outlined,
          label: 'Classes',
          route: '/data/classes',
          view: const DataView(
            whichData: WhichData.classes,
          ),
          whichData: WhichData.classes,
          fabLabel: 'Class',
          fabIcon: Icons.class_outlined,
        ),
      ],
    ),
    Destination(
      icon: Icons.calendar_month,
      label: 'Prebook',
      route: '/prebook',
      view: const PrebookView(),
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
