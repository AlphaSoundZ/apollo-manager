import 'package:apollo_manager/enums/which_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../classes/api.dart';

class AppBar extends StatefulWidget {
  const AppBar({
    super.key,
    required this.backgroundColor,
    required this.whichData,
  });

  final Color backgroundColor;
  final WhichData whichData;

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
  });

  final WhichData whichData;

  @override
  State<SearchAnchors> createState() => _SearchAnchorsState();
}

class _SearchAnchorsState extends State<SearchAnchors> {
  SearchController searchController = SearchController();

  List<int> selectedFilters = [];

  @override
  void didUpdateWidget(SearchAnchors oldWidget) {
    if (widget.whichData != oldWidget.whichData) {
      setState(() {
        selectedFilters.clear();
        searchController.text = "";
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuilt for ${widget.whichData.name}");

    final surfaceContainer = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
      Theme.of(context).colorScheme.surface,
    );

    return SearchAnchor.bar(
      searchController: searchController,
      viewHintText: "Search ${widget.whichData.name}",
      viewTrailing: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
      ],
      barBackgroundColor: MaterialStateColor.resolveWith(
        (states) => surfaceContainer,
      ),
      barElevation: MaterialStateProperty.all(0),
      barLeading: IconButton(
        icon: Icon(
          Icons.search_rounded,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        onPressed: () {},
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
        return [
          // Filter title
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Filters", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
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
          // Filter chips
          const Divider(),
          QuickSearch(
            whichData: widget.whichData,
            query: controller.text,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 16,
              ),
            ),
            title: const Text("User 1"),
            onTap: () {},
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 16,
              ),
            ),
            title: const Text("User 2"),
            onTap: () {},
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 16,
              ),
            ),
            title: const Text("User 3"),
            onTap: () {},
          ),
        ];
      },
    );
  }
}

class QuickSearch extends StatefulWidget {
  const QuickSearch({super.key, required this.whichData, required this.query});

  final WhichData whichData;
  final String query;

  @override
  State<QuickSearch> createState() => _QuickSearchState();
}

class _QuickSearchState extends State<QuickSearch> {
  List<dynamic> responseData = [];

  @override
  void initState() {
    super.initState();

    quickSearch(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> quickSearch(String query) async {
    debugPrint("search for: $query");
    if (query.isEmpty) {
      return;
    }

    List<dynamic> response = await Api().fetchData(
      whichData: widget.whichData,
      params: {
        "query": query,
        "size": 5,
      },
    );

    debugPrint(response.toString());

    setState(() {
      responseData = response;
    });
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
