import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/views/data_view.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_sub_drawer.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_bar.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar_widget.dart' as search_bar;
import '../destinations.dart';
import '../widgets/side_sheet_widget.dart';
import '../models/data_model.dart';
import '../views/stack_template_view.dart';

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
  List<dynamic> stack = [];

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
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.view != oldWidget.view || widget.subView != oldWidget.subView) {
      setState(() {
        stack.clear();
      });
    }
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

    final surfaceContainer = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
      Theme.of(context).colorScheme.surface,
    );

    return MultiProvider(
      providers: [
        ListenableProvider<DataModel>(
            create: (context) =>
                DataModel()), // TODO: separate providers for each data type, else it will rebuild everything
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
                        stack.clear();
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
                        whichData: destinations[selectedView]
                                .subDestinations
                                .isNotEmpty
                            ? destinations[selectedView]
                                .subDestinations[selectedSubView]
                                .whichData
                            : WhichData.users,
                        onSearchSubmit: (
                            {required query,
                            required filters,
                            required WhichData whichData}) {
                          // show results
                          setState(() {
                            stack.clear();
                            stack.add(
                              StackView(
                                title: "Search Results",
                                onPop: () {
                                  setState(() {
                                    stack.removeLast();
                                  });
                                },
                                child: DataView(
                                  whichData: whichData,
                                  params: {"query": query},
                                ),
                              ),
                            );
                          });
                        },
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
                                  stack.clear();
                                  selectedSubView = index;
                                  showSideSheet =
                                      false; // TODO: When View Changes, the SideSheet changes instantly, so it changes first and then animates out (need to fix)
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
                          // MAIN VIEW
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(56.0 / 2),
                              color: surfaceContainer,
                            ),
                            child: IndexedStack(
                              index: stack.length,
                              children: [
                                // MAIN
                                (destinations[selectedView]
                                        .subDestinations
                                        .isEmpty)
                                    ? IndexedStack(
                                        index: selectedSubView,
                                        children: [
                                          destinations[selectedView].view
                                        ],
                                      )
                                    : IndexedStack(
                                        index: selectedSubView,
                                        children: destinations[selectedView]
                                            .subDestinations
                                            .map<Widget>((e) => e.view)
                                            .toList(),
                                      ),
                                // STACKED VIEW (like search results, user details etc.)
                                ...stack,
                              ],
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
                    stack.clear();
                    selectedView = index;
                  });
                },
              ),
      ),
    );
  }
}
