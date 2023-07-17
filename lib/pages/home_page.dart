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
  int selectedIndex = 0;
  bool _isDarkMode = Get.isDarkMode;

  List<Destination> destinations = Destinations().destinations;

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _backgroundColor,
        child: IndexedStack(
          index: selectedView,
          children: destinations.map<Widget>((e) {
            return e.view;
          }).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        destinations: destinations.map<NavigationDestination>((d) {
          return NavigationDestination(
            icon: Icon(d.icon),
            label: d.label,
          );
        }).toList(),
        selectedIndex: selectedView,
        onDestinationSelected: (index) {
          setState(() {
            selectedView = index;
          });
        },
      ),
    );
  }
}
