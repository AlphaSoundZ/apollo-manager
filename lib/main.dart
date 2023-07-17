import 'package:apollo_manager/classes/api.dart';
import 'pages/home_page.dart';
import '/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          transition: Transition.fadeIn,
        ),
      ],
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void initState() {
    super.initState();

    debugPrint('Initializing app');

    Get.changeTheme(ThemeData.light(useMaterial3: true));

    // check if user is logged in
    Api api = Api();

    api.isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        debugPrint('User is logged in');
        Get.offAllNamed("/home");
      } else {
        debugPrint('User is not logged in');
        Get.offAllNamed("/login");
      }
    });
  }
}
