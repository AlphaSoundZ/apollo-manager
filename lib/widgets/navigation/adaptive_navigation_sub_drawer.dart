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

    return SizedBox(
      width: 250,
      child: Drawer(
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        child: ListView(
          children: destinations[selectedView]
              .subDestinations
              .map<Widget>(
                (e) => ListTile(
                  selected:
                      destinations[selectedView].subDestinations.indexOf(e) ==
                          selectedSubView,
                  title: Text(e.label),
                  onTap: () {
                    setState(() {
                      selectedSubView =
                          destinations[selectedView].subDestinations.indexOf(e);
                    });
                    if (widget.onViewSelected != null) {
                      widget.onViewSelected!(selectedSubView);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
