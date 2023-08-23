import 'package:apollo_manager/services/api.dart';
import 'package:provider/provider.dart';
import 'models/data_model.dart';
import 'pages/home_page.dart';
import '/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'destinations.dart';
import 'pages/loading_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainAppProvider());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    debugPrint(
      "rebuild with permissions: ${Provider.of<Destinations>(context, listen: true).withPermissions}",
    );

    return GetMaterialApp(
      initialRoute: '/',
      home: const LoadingPage(),
      getPages: _getPagesFromDestinations(
          Provider.of<Destinations>(context, listen: true).withPermissions),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.orange,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void initState() {
    super.initState();

    // Set default theme
    Get.changeThemeMode(ThemeMode.light);

    //  check if user is logged in
    Api().isLoggedIn().then((token) {
      if (token.isNotEmpty && Get.currentRoute != '/login') {
        debugPrint('User is logged in');

        // get pages
        Api().getPermissions().then((permissions) {
          // update destination permissions in provider
          Provider.of<Destinations>(context, listen: false)
              .updatePermissions(withPermissions: permissions);

          // if there is no specific route, go to home
          if (Get.currentRoute == '/') {
            Get.offAllNamed("/home");
          }
        });
      } else {
        debugPrint('User is not logged in or is on login page');
        Get.offAllNamed("/login");
      }
    });
  }

  List<GetPage<dynamic>> _getPagesFromDestinations(List<int> withPermissions) {
    List<GetPage<dynamic>> pages = [];

    List<Destination> destinations =
        Destinations(withPermissions: withPermissions).destinations;

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

class MainAppProvider extends StatelessWidget {
  const MainAppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<DataModel>(
            create: (context) =>
                DataModel()), // TODO: separate providers for each data type, else it will rebuild everything
        ListenableProvider<Destinations>(
          create: (context) => Destinations(
            withPermissions: [],
          ),
        ),
      ],
      child: const MainApp(),
    );
  }
}
