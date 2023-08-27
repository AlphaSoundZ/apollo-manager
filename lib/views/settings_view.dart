import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();
  late String username = '';
  late String firstName = '';
  late String lastName = '';

  @override
  void initState() {
    super.initState();

    _storage.getString('username').then((value) {
      setState(() {
        username = value;
      });
    });

    _storage.getString('firstName').then((value) {
      setState(() {
        firstName = value;
      });
    });

    _storage.getString('lastName').then((value) {
      setState(() {
        lastName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello $firstName $lastName ($username)',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    Api().logout().then((value) => {
                          scaffoldMessenger.hideCurrentSnackBar(),
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              showCloseIcon: true,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Logged out',
                              ),
                              width: 280.0, // Width of the SnackBar.
                            ),
                          ),
                        });

                    Get.offAllNamed("/login");
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                    );
                    scaffoldMessenger.hideCurrentSnackBar();
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
          ],
        ),
      ),
    );
  }
}
