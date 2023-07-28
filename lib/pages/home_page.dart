import 'package:apollo_manager/widgets/navigation/adaptive_navigation_sub_drawer.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_bar.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar_widget.dart' as search_bar;
import '../destinations.dart';
import '../widgets/side_sheet_widget.dart';
import '../models/data_model.dart';

// Views

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.view = 0,
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

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  bool wideScreen = false;
  bool showSubDrawer = true;
  bool showSideSheet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    Destinations destinationsInstance = Destinations(onFabCancel: () {
      setState(() {
        showSideSheet = false;
      });
    }, onFabSubmit: () {
      setState(() {
        showSideSheet = false;
      });
    });
    List<Destination> destinations = destinationsInstance.destinations;

    return MultiProvider(
      providers: [
        ListenableProvider<DataModel>(create: (context) => DataModel()),
      ],
      child: Scaffold(
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
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                      child: search_bar.AppBar(
                        backgroundColor: _backgroundColor,
                      )),
                  Expanded(
                    child: Row(
                      children: [
                        if (wideScreen &&
                            destinations[selectedView]
                                .subDestinations
                                .isNotEmpty)
                          Container(
                            // SUB-DRAWER
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SubDrawer(
                              selectedView: selectedView,
                              onViewSelected: (int index) {
                                setState(() {
                                  selectedSubView = index;
                                  showSideSheet = false;
                                });
                              },
                              isOpen: showSubDrawer,
                              selectedSubView: selectedSubView,
                              onFABPressed: () {
                                setState(() {
                                  showSideSheet = true;
                                });
                              },
                            ),
                          ),
                        Expanded(
                          child: Container(
                            // MAIN VIEW
                            padding: const EdgeInsets.all(8),
                            child: (destinations[selectedView]
                                    .subDestinations
                                    .isEmpty)
                                ? IndexedStack(
                                    index: selectedSubView,
                                    children: [destinations[selectedView].view],
                                  )
                                : IndexedStack(
                                    index: selectedSubView,
                                    children: destinations[selectedView]
                                        .subDestinations
                                        .map<Widget>((e) => e.view)
                                        .toList(),
                                  ),
                          ),
                        ),
                        if (wideScreen &&
                            destinations[selectedView]
                                .subDestinations
                                .isNotEmpty &&
                            destinations[selectedView]
                                    .subDestinations[selectedSubView]
                                    .fabContent !=
                                null)
                          Container(
                            // SIDE SHEET
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SideSheet(
                              isOpen: showSideSheet,
                              child: destinations[selectedView]
                                  .subDestinations[selectedSubView]
                                  .fabContent!,
                            ),
                          ),
                        const SizedBox(width: 8.0),
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
                onPressed: () {
                  setState(() {
                    showSideSheet = true;
                  });
                },
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
      ),
    );
  }
}
