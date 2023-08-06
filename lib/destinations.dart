import 'package:apollo_manager/views/prebook_view.dart';
import 'package:flutter/material.dart';
import 'views/data_view.dart';
import '../enums/which_data.dart';
import '../views/action_views/create_user_view.dart';
import '../views/action_views/create_device_view.dart';
import '../views/settings_view.dart';

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
  Destinations({this.onFabCancel, this.onFabSubmit, this.onShowDetails});

  final void Function()? onFabCancel;
  final void Function()? onFabSubmit;
  final void Function(WhichData whichData, int id)? onShowDetails;

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
          view: DataView(
            whichData: WhichData.users,
            onShowDetails: (id) => onShowDetails != null
                ? onShowDetails!(WhichData.users, id)
                : null,
          ),
          whichData: WhichData.users,
          fabLabel: 'User',
          fabIcon: Icons.person_add_outlined,
          fabContent: CreateUserViewContent(
            key: UniqueKey(),
            onCancel: onFabCancel,
            onSubmit: onFabSubmit,
          ),
        ),
        SubDestination(
          icons: Icons.credit_card_outlined,
          label: 'Usercards',
          route: '/data/usercards',
          view: DataView(
            whichData: WhichData.usercards,
            onShowDetails: (id) => onShowDetails != null
                ? onShowDetails!(WhichData.usercards, id)
                : null,
          ),
          whichData: WhichData.usercards,
          fabLabel: 'Usercard',
          fabIcon: Icons.credit_card_outlined,
        ),
        SubDestination(
          icons: Icons.devices_outlined,
          label: 'Devices',
          route: '/data/devices',
          view: DataView(
            whichData: WhichData.devices,
            onShowDetails: (id) => onShowDetails != null
                ? onShowDetails!(WhichData.devices, id)
                : null,
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
          view: DataView(
            whichData: WhichData.tokens,
            onShowDetails: (id) => onShowDetails != null
                ? onShowDetails!(WhichData.tokens, id)
                : null,
          ),
          whichData: WhichData.tokens,
          fabLabel: 'Token',
          fabIcon: Icons.token_outlined,
        ),
        SubDestination(
          icons: Icons.class_outlined,
          label: 'Classes',
          route: '/data/classes',
          view: DataView(
            whichData: WhichData.classes,
            onShowDetails: (id) => onShowDetails != null
                ? onShowDetails!(WhichData.classes, id)
                : null,
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
      view: const SettingsView(),
    ),
  ];
}
