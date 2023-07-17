import 'package:flutter/material.dart';
import '../../destinations.dart';

class AdaptiveNavigationRail extends StatelessWidget {
  AdaptiveNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.backgroundColor,
    this.onDestinationSelected,
  });

  final int selectedIndex;
  final Color backgroundColor;
  final ValueChanged<int>? onDestinationSelected;

  final List<Destination> destinations = Destinations().destinations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return NavigationRail(
      selectedIndex: selectedIndex,
      backgroundColor: backgroundColor,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: colorScheme.tertiaryContainer,
            foregroundColor: colorScheme.onTertiaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            onPressed: () {},
            child: const Icon(Icons.add),
          )
        ],
      ),
      groupAlignment: -0.85,
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: Icon(d.icon),
          label: Text(d.label),
        );
      }).toList(),
    );
  }
}
