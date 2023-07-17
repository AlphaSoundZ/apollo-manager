import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../classes/api.dart';

// Pages
import '../views/data_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  bool _isDarkMode = Get.isDarkMode;

  final _drawerStateKey = GlobalKey<DrawerControllerState>();
  bool _drawerOpen = false;

  final List<NavigationRailDestination> _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.data_array),
      label: Text('Data'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.search),
      label: Text('Search'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.calendar_month),
      label: Text('Prebook'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apollo Manager"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              groupAlignment: -1,
              destinations: _destinations,
              selectedIndex: currentPage,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPage = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  debugPrint('Menu button pressed');
                  _drawerOpen
                      ? _drawerStateKey.currentState!.close()
                      : _drawerStateKey.currentState!.open();
                  _drawerOpen = _drawerOpen ? false : true;
                },
              ),
              trailing: IconButton(
                icon: _isDarkMode
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
                onPressed: () {
                  Get.changeThemeMode(
                      _isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  setState(() {
                    _isDarkMode = _isDarkMode ? false : true;
                  });
                },
              ),
            ),
            // This is the main content.
            Expanded(
              child: IndexedStack(
                index: currentPage,
                children: [
                  const Center(
                    child: Text('Data'),
                  ),
                  const Center(
                    child: DataListView(),
                  ),
                  Center(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: () {
                              Api api = Api();
                              api.logout();
                              Get.offAllNamed("/login");
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        debugPrint('Search closed');
        close(context, "");
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text('Search results'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search suggestions'),
    );
  }
}
