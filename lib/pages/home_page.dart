import 'package:apollo_manager/widgets/navigation/adaptive_navigation_sub_drawer.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_bar.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_rail.dart';
import '../widgets/app_bar_widget.dart' as search_bar;
import 'package:flutter/material.dart';
import '../destinations.dart';
import '../widgets/navigation/adaptive_navigation_sub_drawer.dart';

// Views

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.view,
    this.subView = 0,
  });

  final int view;
  final int subView;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedView = 0;
  int selectedSubView = 0;

  @override
  void initState() {
    super.initState();

    selectedView = widget.view;
    selectedSubView = widget.subView;
  }

  List<Destination> destinations = Destinations().destinations;

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  bool wideScreen = false;
  bool showSubDrawer = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (wideScreen)
            Padding(
              // NAVIGATION RAIL
              padding: const EdgeInsets.only(right: 8.0),
              child: AdaptiveNavigationRail(
                selectedIndex: selectedView,
                backgroundColor: _backgroundColor,
                onDestinationSelected: (int index) {
                  setState(
                    () {
                      selectedView = index;
                      selectedSubView = 0;
                    },
                  );
                },
                onMenuButtonPressed: () {
                  setState(() {
                    showSubDrawer = !showSubDrawer;
                  });
                },
              ),
            ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  // SEARCH BAR
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: search_bar.AppBar(backgroundColor: _backgroundColor),
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (wideScreen &&
                          destinations[selectedView]
                              .subDestinations
                              .isNotEmpty &&
                          showSubDrawer == true)
                        Container(
                          // SUB-DRAWER
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: SubDrawer(
                            selectedView: selectedView,
                            onViewSelected: (int index) {
                              setState(() {
                                selectedSubView = index;
                              });
                            },
                            selectedSubView: selectedSubView,
                          ),
                        ),
                      Expanded(
                        child: Container(
                          // MAIN VIEW
                          padding: const EdgeInsets.all(8),
                          //color: _backgroundColor,
                          child: IndexedStack(
                            index: selectedView,
                            children: destinations.map<Widget>((e) {
                              if (e.subDestinations.isEmpty) {
                                return IndexedStack(
                                  index: selectedSubView,
                                  children: [e.view],
                                );
                              }

                              return IndexedStack(
                                index: selectedSubView,
                                children: e.subDestinations
                                    .map<Widget>((e) => e.view)
                                    .toList(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: wideScreen
          ? null
          : FloatingActionButton(
              backgroundColor: _colorScheme.tertiaryContainer,
              foregroundColor: _colorScheme.onTertiaryContainer,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: wideScreen
          ? null
          : AdaptiveNavigationBar(
              selectedView: selectedView,
              onDestinationSelected: (index) {
                setState(() {
                  selectedView = index;
                });
              },
            ),
    );
  }
}
