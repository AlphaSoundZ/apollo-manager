import 'services/api.dart';
import 'package:provider/provider.dart';
import 'enums/app_state.dart';
import 'models/data_model.dart';
import 'pages/home_page.dart';
import '/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'destinations.dart';
import 'pages/loading_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future main() async {
  await dotenv.load(fileName: ".env");
  // usePathUrlStrategy(); DOTO: uncomment this when deploying not to github pages
  runApp(const MainAppProvider());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

LoginState appState = LoginState.loading;
String currentRoute = Uri.base.path;

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    if (appState == LoginState.loading) {
      return MaterialApp(
        initialRoute: "/",
        // ignore route
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const LoadingPage(),
          );
        },
        home: const LoadingPage(),
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
    return GetMaterialApp(
      initialRoute: currentRoute,
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
      // 404
      unknownRoute: GetPage(
        name: '/404',
        page: () => const Scaffold(
          body: Center(
            child: Text(
              '404',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Set default theme
    Get.changeThemeMode(ThemeMode.light);

    //  check if user is logged in
    Api().isLoggedIn().then((token) {
      if (token.isNotEmpty && currentRoute != '/login') {
        debugPrint('User is logged in');

        // get pages
        Api().getPermissions().then((permissions) {
          // update destination permissions in provider
          Provider.of<Destinations>(context, listen: false)
              .updatePermissions(withPermissions: permissions);

          debugPrint('Route: ${Uri.base.path}');

          setState(() {
            if (kIsWeb) {
              currentRoute = Uri.base.path == "/" ? "/home" : Uri.base.path;
            } else {
              currentRoute = "/home";
            }
            appState = LoginState.loggedIn;
          });
        });
      } else {
        debugPrint('User is not logged in or is on login page');
        setState(() {
          currentRoute = "/login";
          appState = LoginState.loggedOut;
        });

        // Get.offAllNamed("/login");
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
