import 'package:flutter/material.dart';
import 'enums/permissions.dart';
import 'views/action_views/create_book_view.dart';
import 'views/action_views/create_prebook_view.dart';
import 'views/action_views/create_token_view.dart';
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
    this.permission,
    this.altPermission,
  });
  final IconData icon;
  final String label;
  final String route;
  final dynamic view;
  List<SubDestination> subDestinations;
  final Permissions? permission;
  final Permissions? altPermission;
}

class SubDestination {
  SubDestination({
    required this.icon,
    required this.label,
    required this.route,
    required this.view,
    this.whichData,
    required this.fabLabel,
    this.fabIcon,
    this.fabContent,
    this.showAmount = true,
    this.permission,
    this.altPermission,
  });
  final IconData icon;
  final String label;
  final String route;
  final dynamic view;
  final WhichData? whichData;
  final String fabLabel;
  final IconData? fabIcon;
  final Widget? fabContent;
  final bool showAmount;
  final Permissions? permission;
  final Permissions? altPermission;
}

class Destinations extends ChangeNotifier {
  Destinations(
      {required this.withPermissions,
      this.onFabCancel,
      this.onFabSubmit,
      this.onShowDetails});

  void Function()? onFabCancel;
  void Function()? onFabSubmit;
  void Function(WhichData whichData, int id)? onShowDetails;
  List<int> withPermissions;

  // notifys listeners on change
  void updatePermissions({required List<int> withPermissions}) {
    this.withPermissions = withPermissions;
    debugPrint("updating permissions");
    notifyListeners();
  }

  late final List<Destination> _destinations = <Destination>[
    Destination(
      icon: Icons.data_array,
      label: 'Data',
      route: '/data',
      subDestinations: [
        SubDestination(
          icon: Icons.group_outlined,
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
          permission: Permissions.crudUser,
        ),
        SubDestination(
          icon: Icons.credit_card_outlined,
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
          permission: Permissions.crudUsercard,
        ),
        SubDestination(
          icon: Icons.devices_outlined,
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
            key: UniqueKey(),
            onCancel: onFabCancel,
            onSubmit: onFabSubmit,
          ),
          permission: Permissions.crudDevice,
        ),
        SubDestination(
          icon: Icons.token_outlined,
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
          fabContent: CreateTokenViewContent(
            key: UniqueKey(),
            onCancel: onFabCancel,
            onSubmit: onFabSubmit,
          ),
          permission: Permissions.crudToken,
        ),
        SubDestination(
          icon: Icons.class_outlined,
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
          permission: Permissions.crudUserClass,
        ),
      ],
    ),
    Destination(
        icon: Icons.calendar_month,
        label: 'Book',
        route: '/book',
        subDestinations: [
          SubDestination(
            whichData: WhichData.bookings,
            icon: Icons.devices_outlined,
            label: 'Bookings',
            showAmount: false,
            route: '/book/bookings',
            view: DataView(
              whichData: WhichData.bookings,
              onShowDetails: (id) => onShowDetails != null
                  ? onShowDetails!(WhichData.bookings, id)
                  : null,
            ),
            fabLabel: 'Booking',
            fabIcon: Icons.nfc_outlined,
            fabContent: CreateBookViewContent(
              key: UniqueKey(),
              onCancel: onFabCancel,
              onSubmit: onFabSubmit,
            ),
            permission: Permissions.book,
          ),
          SubDestination(
            whichData: WhichData.prebookings,
            icon: Icons.calendar_today_outlined,
            label: 'Prebookings',
            showAmount: false,
            route: '/book/prebookings',
            view: DataView(
              whichData: WhichData.prebookings,
              onShowDetails: (id) => onShowDetails != null
                  ? onShowDetails!(WhichData.prebookings, id)
                  : null,
            ),
            fabLabel: 'Prebooking',
            fabIcon: Icons.add,
            fabContent: CreatePrebookViewContent(
              key: UniqueKey(),
              onCancel: onFabCancel,
              onSubmit: onFabSubmit,
            ),
            permission: Permissions.prebook,
            altPermission: Permissions.crudPrebook,
          ),
        ]),
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

  List<Destination> get destinations {
    List<Destination> destiantions = [];

    // iterate through destinations
    for (Destination destination in _destinations) {
      List<SubDestination> subDestinations = [];

      // check if there are no subDestinations and if the destination has permission
      if (destination.permission != null &&
          (!withPermissions.contains(destination.permission!.value)) &&
          (destination.altPermission != null &&
              !withPermissions.contains(destination.altPermission!.value))) {
        continue;
      }

      // iterate through subDestinations
      for (SubDestination subDestination in destination.subDestinations) {
        if ((subDestination.permission == null ||
                withPermissions.contains(subDestination.permission!.value)) ||
            (subDestination.altPermission != null &&
                withPermissions
                    .contains(subDestination.altPermission!.value))) {
          subDestinations.add(subDestination);
        }
      }

      if (subDestinations.isNotEmpty) {
        destination.subDestinations = subDestinations;
      } else if (destination.subDestinations.isNotEmpty) {
        continue;
      }

      destiantions.add(destination);
    }

    return destiantions;
  }
}
