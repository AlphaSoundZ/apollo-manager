import 'package:apollo_manager/widgets/navigation/adaptive_navigation_bar.dart';
import 'package:apollo_manager/widgets/navigation/adaptive_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../classes/api.dart';
import '../destinations.dart';

// Views
import '../views/data_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedView = 0;
  bool _isDarkMode = Get.isDarkMode;

  List<Destination> destinations = Destinations().destinations;

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  bool wideScreen = false;

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
            AdaptiveNavigationRail(
              selectedIndex: selectedView,
              backgroundColor: _backgroundColor,
              onDestinationSelected: (int index) {
                setState(
                  () {
                    selectedView = index;
                  },
                );
              },
            ),
          Expanded(
            child: Container(
              color: _backgroundColor,
              child: IndexedStack(
                index: selectedView,
                children: destinations.map<Widget>((e) {
                  return e.view;
                }).toList(),
              ),
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
