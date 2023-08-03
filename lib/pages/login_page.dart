import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../services/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final api = Api();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // Remove the token
    _storage.remove('token');
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Form(
              key: _formKey,
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        //add icon
                        prefixIcon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        labelText: 'Username',
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim() == "") {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          _handleLogin(scaffoldMessenger);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          _handleLogin(scaffoldMessenger);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      onPressed: () async {
                        _handleLogin(scaffoldMessenger);
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
            if (_loading)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    // call the api
    final response =
        await api.login(usernameController.text, passwordController.text);

    // log the response

    // show a snackbar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(response['message']),
      ),
    );

    if (response['code'] == 200) {
      await _storage.setString('token', response['jwt']);

      debugPrint('Token: ${response['jwt']}');

      // Push to the home page
      Get.offNamed("/home");
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });

      // Set password as empty
      passwordController.text = "";
    }
  }
}
