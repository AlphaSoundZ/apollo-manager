import 'package:flutter/material.dart';
import '../../destinations.dart';

class AdaptiveNavigationBar extends StatelessWidget {
  const AdaptiveNavigationBar({
    super.key,
    required this.selectedView,
    required this.destinations,
    this.onDestinationSelected,
  });

  final int selectedView;
  final ValueChanged<int>? onDestinationSelected;
  final List<Destination> destinations;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      //backgroundColor: Colors.white,
      destinations: destinations.map<NavigationDestination>((d) {
        return NavigationDestination(
          icon: Icon(d.icon),
          label: d.label,
        );
      }).toList(),
      selectedIndex: selectedView,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
