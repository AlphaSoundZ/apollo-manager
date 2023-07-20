import 'package:flutter/material.dart';
import '../../destinations.dart';

class SubDrawer extends StatefulWidget {
  const SubDrawer({
    super.key,
    required this.selectedView,
    required this.selectedSubView,
    this.onViewSelected,
  });

  final int selectedView;
  final int selectedSubView;
  final ValueChanged<int>? onViewSelected;

  @override
  State<SubDrawer> createState() => SubDrawerState();
}

class SubDrawerState extends State<SubDrawer> {
  int selectedView = 0;
  int selectedSubView = 0;

  List<Destination> destinations = Destinations().destinations;

  @override
  Widget build(BuildContext context) {
    selectedView = widget.selectedView;
    selectedSubView = widget.selectedSubView;

    return Container(
      width: 250,
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FloatingActionButton.extended(
            heroTag: "Create New",
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
            label: Text(
                "New ${destinations[selectedView].subDestinations[selectedSubView].fabLabel}"),
            icon: Icon(destinations[selectedView]
                .subDestinations[selectedSubView]
                .fabIcon),
            onPressed: () {},
            elevation: 0,
          ),
          const SizedBox(height: 16),
          Column(
            children: destinations[selectedView]
                .subDestinations
                .map<Widget>(
                  (e) => SizedBox(
                    height: 32.0,
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      icon: Icon(e.icon),
                      label: Text(e.label),
                      style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        backgroundColor: MaterialStateProperty.all<Color>(
                          selectedSubView ==
                                  destinations[selectedView]
                                      .subDestinations
                                      .indexOf(e)
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedSubView = destinations[selectedView]
                              .subDestinations
                              .indexOf(e);
                        });
                        if (widget.onViewSelected != null) {
                          widget.onViewSelected!(selectedSubView);
                        }
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
