import 'package:apollo_manager/classes/api.dart';
import 'pages/home_page.dart';
import '/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'destinations.dart';
import 'pages/loading_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Destination> destinations = Destinations().destinations;
  List<GetPage> pages = [];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      home: const LoadingPage(),
      getPages: pages,
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void initState() {
    super.initState();

    debugPrint('Initializing app');

    Get.changeTheme(ThemeData.light(useMaterial3: true));

    // Get Pages
    pages = _getPagesFromDestinations();

    // check if user is logged in
    Api api = Api();

    api.isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn && Get.currentRoute != '/login') {
        debugPrint('User is logged in');

        if (Get.currentRoute != '/home') {
          Get.offAllNamed("/home");
        }
      } else {
        debugPrint('User is not logged in or is on login page');
        Get.offAllNamed("/login");
      }
    });
  }

  _getPagesFromDestinations() {
    List<GetPage> pages = [];

    for (var i = 0; i < destinations.length; i++) {
      pages.add(
        GetPage(
          name: destinations[i].route,
          page: () => HomePage(
            view: i,
          ),
        ),
      );

      for (var j = 0; j < destinations[i].subDestinations.length; j++) {
        pages.add(
          GetPage(
            name: destinations[i].subDestinations[j].route,
            page: () => HomePage(
              view: i,
              subView: j,
            ),
          ),
        );
      }
    }

    // other destinations that are not in the navigation rail/bar
    pages.add(GetPage(
      name: '/login',
      page: () => const LoginPage(),
    ));

    pages.add(GetPage(
      name: '/home',
      page: () => const HomePage(),
    ));

    return pages;
  }
}
