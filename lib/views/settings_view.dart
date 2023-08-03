// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/api.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Api api = Api();
                api.logout();
                Get.offAllNamed("/login");
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      Get.isDarkMode
                          ? 'Switched to light theme'
                          : 'Switched to dark theme',
                    ),
                    width: 280.0, // Width of the SnackBar.
                  ),
                );
              },
              child: const Text('Change Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
