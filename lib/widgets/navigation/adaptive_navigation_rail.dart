import 'package:flutter/material.dart';
import '../../destinations.dart';

class AdaptiveNavigationRail extends StatelessWidget {
  AdaptiveNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.backgroundColor,
    this.onDestinationSelected,
    this.onMenuButtonPressed,
  });

  final int selectedIndex;
  final Color backgroundColor;
  final ValueChanged<int>? onDestinationSelected;
  final VoidCallback? onMenuButtonPressed;

  final List<Destination> destinations = Destinations().destinations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceContainer = Color.alphaBlend(
      colorScheme.primary.withOpacity(0.08),
      colorScheme.surface,
    );
    return NavigationRail(
      selectedIndex: selectedIndex,
      backgroundColor: surfaceContainer,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          const SizedBox(height: 4),
          IconButton(
            onPressed: () {
              if (onMenuButtonPressed != null) {
                onMenuButtonPressed!();
              }
            },
            icon: const Icon(Icons.menu),
          ),
          const SizedBox(height: 20),
        ],
      ),
      groupAlignment: -1,
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: Icon(d.icon),
          label: Text(d.label),
        );
      }).toList(),
    );
  }
}
