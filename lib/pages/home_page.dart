import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/views/data_view.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_sub_drawer.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_bar.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stack_view_model.dart';
import '../widgets/app_bar_widget.dart' as search_bar;
import '../destinations.dart';
import '../widgets/side_sheet_widget.dart';
import '../views/stack_views/stack_view.dart';
import '../views/stack_views/stack_details_view.dart';

// Views

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.view = 0, this.subView = 0});

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
  Widget sideSheetContent = Container();

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

  bool isDetailsOnTop() {
    if (stack.isNotEmpty) {
      if (stack.last is DetailsView) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    late Destinations destinationsInstance;

    dynamic dest = Provider.of<Destinations>(context, listen: true);

    destinationsInstance = Destinations(
      withPermissions: dest.withPermissions,
      onFabCancel: () {
        setState(() {
          showSideSheet = false;
        });
      },
      onFabSubmit: () {
        setState(() {
          showSideSheet = false;
        });
      },
      onShowDetails: (WhichData whichData, int id) {
        setState(() {
          stack.add(DetailsView(
            id: id,
            whichData: whichData,
            onPop: () {
              setState(() {
                stack.removeLast();
              });
            },
            onEdit: () {
              setState(() {
                sideSheetContent = whichData.editSideSheet(
                  context,
                  id,
                  onCancel: () {
                    setState(() {
                      showSideSheet = false;
                    });
                  },
                  onSave: () {
                    setState(() {
                      showSideSheet = false;
                    });
                  },
                  onDelete: () {
                    setState(() {
                      showSideSheet = false;
                    });
                  },
                );
                showSideSheet = true;
              });
            },
          ));
        });
      },
    );

    List<Destination> destinations = destinationsInstance.destinations;

    // add destinations based on permissions

    final surfaceContainer = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
      Theme.of(context).colorScheme.surface,
    );

    return Scaffold(
      body: Row(
        children: [
          if (wideScreen)
            Padding(
              // NAVIGATION RAIL
              padding: const EdgeInsets.only(right: 8.0),
              child: AdaptiveNavigationRail(
                destinations: destinations,
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
                                  .isNotEmpty &&
                              destinations[selectedView]
                                      .subDestinations[selectedSubView]
                                      .whichData !=
                                  null
                          ? destinations[selectedView]
                              .subDestinations[selectedSubView]
                              .whichData!
                          : WhichData.users,
                      onQuickSearchSelected: ({
                        required id,
                        required WhichData whichData,
                      }) {
                        // show details
                        setState(() {
                          stack.clear();
                          stack.add(
                            DetailsView(
                              id: id,
                              whichData: whichData,
                              onPop: () {
                                setState(() {
                                  stack.removeLast();
                                });
                              },
                              onEdit: () {
                                setState(() {
                                  sideSheetContent = whichData.editSideSheet(
                                    context,
                                    id,
                                    onCancel: () {
                                      setState(() {
                                        showSideSheet = false;
                                      });
                                    },
                                    onSave: () {
                                      setState(() {
                                        showSideSheet = false;
                                      });
                                    },
                                    onDelete: () {
                                      setState(() {
                                        showSideSheet = false;
                                      });
                                    },
                                  );
                                  showSideSheet = true;
                                });
                              },
                            ),
                          );
                        });
                      },
                      onSearchSubmit: (
                          {required query,
                          required filters,
                          required WhichData whichData}) {
                        // show results
                        setState(() {
                          stack.clear();
                          stack.add(
                            StackView(
                              stackViewModel: StackViewModel(
                                title: "Search Results",
                                content: DataView(
                                  whichData: whichData,
                                  params: {"query": query.trim()},
                                  onShowDetails: (id) {
                                    setState(() {
                                      if (isDetailsOnTop()) {
                                        stack.removeLast();
                                      }
                                      stack.add(
                                        DetailsView(
                                          id: id,
                                          whichData: whichData,
                                          onEdit: () {
                                            setState(() {
                                              sideSheetContent =
                                                  whichData.editSideSheet(
                                                context,
                                                id,
                                                onCancel: () {
                                                  setState(() {
                                                    showSideSheet = false;
                                                  });
                                                },
                                                onSave: () {
                                                  setState(() {
                                                    showSideSheet = false;
                                                  });
                                                },
                                                onDelete: () {
                                                  setState(() {
                                                    showSideSheet = false;
                                                  });
                                                },
                                              );
                                              showSideSheet = true;
                                            });
                                          },
                                          onPop: () {
                                            setState(() {
                                              stack.removeLast();
                                            });
                                          },
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                              onPop: () {
                                setState(() {
                                  stack.removeLast();
                                });
                              },
                            ),
                          );
                        });
                      },
                    )),
                Expanded(
                  child: Row(
                    children: [
                      if (wideScreen &&
                          destinations[selectedView].subDestinations.isNotEmpty)
                        Container(
                          // SUB-DRAWER
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SubDrawer(
                            destinations: destinations,
                            selectedView: selectedView,
                            onViewSelected: (int index) {
                              setState(() {
                                stack.clear();
                                selectedSubView = index;
                              });
                            },
                            isOpen: showSubDrawer,
                            selectedSubView: selectedSubView,
                            onFABPressed: () {
                              if (destinations[selectedView]
                                      .subDestinations[selectedSubView]
                                      .fabContent ==
                                  null) {
                                return;
                              }
                              setState(() {
                                sideSheetContent = destinations[selectedView]
                                    .subDestinations[selectedSubView]
                                    .fabContent!;
                                showSideSheet = true;
                              });
                            },
                          ),
                        ),
                      Expanded(
                        // MAIN VIEW
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
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
                                    ? destinations[selectedView].view
                                    : destinations[selectedView]
                                        .subDestinations
                                        .map<Widget>((e) => e.view)
                                        .toList()[selectedSubView],
                                // STACKED VIEW (like search results, user details etc.)
                                ...stack,
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (wideScreen &&
                          destinations[selectedView].subDestinations.isNotEmpty)
                        Container(
                          // SIDE SHEET
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SideSheet(
                            destinations: destinations,
                            isOpen: showSideSheet,
                            child: sideSheetContent,
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
              // backgroundColor: _colorScheme.tertiaryContainer,
              // foregroundColor: _colorScheme.onTertiaryContainer,
              onPressed: () {
                setState(() {
                  sideSheetContent = destinations[selectedView]
                      .subDestinations[selectedSubView]
                      .fabContent!;
                  showSideSheet = true;
                });
              },
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: wideScreen
          ? null
          : AdaptiveNavigationBar(
              destinations: destinations,
              selectedView: selectedView,
              onDestinationSelected: (index) {
                setState(() {
                  stack.clear();
                  selectedView = index;
                });
              },
            ),
    );
  }
}
