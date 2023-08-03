import 'package:apollo_manager/enums/which_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../classes/api.dart';

class AppBar extends StatefulWidget {
  const AppBar({
    super.key,
    required this.backgroundColor,
    required this.whichData,
    required this.onSearchSubmit,
    required this.onQuickSearchSelected,
  });

  final Color backgroundColor;
  final WhichData whichData;
  final Function({
    required String query,
    required List<int> filters,
    required WhichData whichData,
  }) onSearchSubmit;
  final Function({
    required WhichData whichData,
    required int id,
  }) onQuickSearchSelected;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  bool wideScreen = false;
  String searchQuery = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 48,
      child: Row(
        children: [
          if (wideScreen)
            SizedBox(
              // Logo + Apollo title
              width: 266,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.rocket_rounded,
                    size: 34,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Apollo",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SearchAnchors(
                    whichData: widget.whichData,
                    onSearchSubmit: ({required query, required filters}) =>
                        widget.onSearchSubmit(
                      query: query,
                      filters: filters,
                      whichData: widget.whichData,
                    ),
                    onQuickSearchSelected: (
                            {required id, required whichData}) =>
                        widget.onQuickSearchSelected(
                      id: id,
                      whichData: whichData,
                    ),
                  ),
                ),
                const SizedBox(width: 298),
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 25,
                    ),
                    onPressed: () {
                      Get.offAllNamed(
                        "/settings",
                      );
                    },
                    iconSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchAnchors extends StatefulWidget {
  const SearchAnchors({
    super.key,
    required this.whichData,
    required this.onSearchSubmit,
    required this.onQuickSearchSelected,
  });

  final WhichData whichData;
  final Function({
    required String query,
    required List<int> filters,
  }) onSearchSubmit;
  final Function({
    required WhichData whichData,
    required int id,
  }) onQuickSearchSelected;

  @override
  State<SearchAnchors> createState() => _SearchAnchorsState();
}

class _SearchAnchorsState extends State<SearchAnchors> {
  SearchController searchController = SearchController();

  List<int> selectedFilters = [];
  List<dynamic> quickSearchResults = [];
  late QuickSearch quickSearch = QuickSearch(
    whichData: widget.whichData,
  );

  @override
  void didUpdateWidget(SearchAnchors oldWidget) {
    if (widget.whichData != oldWidget.whichData) {
      setState(() {
        selectedFilters.clear();
        quickSearchResults.clear();
        searchController.clear();
        quickSearch = QuickSearch(
          whichData: widget.whichData,
        );
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuilding search anchors: ${quickSearchResults.length}");
    final surfaceContainer = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
      Theme.of(context).colorScheme.surface,
    );

    return SearchAnchor.bar(
      searchController: searchController,
      viewHintText: "Search ${widget.whichData.name}",
      viewTrailing: [
        IconButton(
          onPressed: () {
            searchController.closeView(searchController.text);
          },
          icon: const Icon(Icons.arrow_drop_up),
        )
      ],
      viewLeading: IconButton(
        icon: const Icon(Icons.search_rounded),
        onPressed: () {
          if (searchController.text.isNotEmpty || selectedFilters.isNotEmpty) {
            widget.onSearchSubmit(
                query: searchController.text, filters: selectedFilters);
            searchController.closeView(searchController.text);
          }
        },
      ),
      barBackgroundColor: MaterialStateColor.resolveWith(
        (states) => surfaceContainer,
      ),
      barElevation: MaterialStateProperty.all(0),
      barLeading: IconButton(
        icon: Icon(
          Icons.search_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          // run on search submit
          if (searchController.text.isNotEmpty || selectedFilters.isNotEmpty) {
            widget.onSearchSubmit(
                query: searchController.text, filters: selectedFilters);
          }
        },
      ),
      barShape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      barHintText: "Search ${widget.whichData.name}",
      barTrailing: [
        IconButton(
          onPressed: () => searchController.openView(),
          icon: const Icon(Icons.tune),
        )
      ],
      dividerColor: Theme.of(context).colorScheme.onSurface,
      suggestionsBuilder: (context, controller) {
        // TODO: add tabs for each search category; add async to this function when it's available;
        quickSearch.search(searchController.text).then((value) {
          debugPrint("rebuilding suggestions: ${value.length}");
          setState(() {
            quickSearchResults = value;
          });
          // force rebuild
        });
        return [
          // Filter title
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Filters", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 7),
                Filters(
                  whichData: widget.whichData,
                  onSelected: (value) {
                    debugPrint("selected: $value");
                    if (selectedFilters.contains(value)) {
                      selectedFilters.remove(value);
                    } else {
                      selectedFilters.add(value);
                    }
                  },
                  selectedFilters: selectedFilters,
                ),
              ],
            ),
          ),
          const Divider(),
          ...List.generate(
            quickSearchResults.length,
            (index) {
              return ListTile(
                onTap: () {
                  searchController.closeView(
                    quickSearchResults[index].content.title,
                  );
                  // call onQuickSearchSubmit
                  widget.onQuickSearchSelected(
                    whichData: widget.whichData,
                    id: quickSearchResults[index].id,
                  );
                },
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: Icon(
                    widget.whichData.icons.single,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    size: 16,
                  ),
                ),
                title: Text(quickSearchResults[index].content.title),
                subtitle: Row(
                  children: [
                    Text(quickSearchResults[index].content.subTitle),
                    const Spacer(),
                    Text(quickSearchResults[index].content.leading),
                  ],
                ),
              );
            },
          ).toList(),
        ];
      },
    );
  }
}

class QuickSearch {
  QuickSearch({required this.whichData});

  final WhichData whichData;

  List<dynamic> responseData = [];

  Future<List<dynamic>> search(String query) async {
    debugPrint("search for: $query");
    query = query.trim();
    if (query.isEmpty) {
      responseData.clear();
    } else {
      List<dynamic> response = await Api().fetchData(
        whichData: whichData,
        params: {
          "query": query,
          "size": 7,
        },
      );

      responseData = response;
    }

    debugPrint(responseData.toString());
    return responseData;
  }
}

class Filters extends StatefulWidget {
  const Filters({
    super.key,
    required this.whichData,
    required this.onSelected,
    required this.selectedFilters,
  });

  final WhichData whichData;
  final Function(int index) onSelected;
  final List<int> selectedFilters;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    final surfaceContainerHigh = Color.alphaBlend(
      Theme.of(context).colorScheme.surfaceTint.withOpacity(0.11),
      Theme.of(context).colorScheme.surface,
    );

    return Wrap(
      runSpacing: 16,
      spacing: 8,
      children: [
        ...List.generate(
          3,
          (index) {
            return FilterChip(
              label: Text("Filter ${index + 1}"),
              onSelected: (value) {
                setState(() {
                  widget.onSelected(index);
                });
              },
              selected: widget.selectedFilters.contains(index),
              backgroundColor: surfaceContainerHigh,
            );
          },
        ).toList(),
      ],
    );
  }
}
