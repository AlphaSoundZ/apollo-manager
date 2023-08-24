import 'package:apollo_manager/services/api.dart';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_sidesheet_view.dart';
import '../../enums/permissions.dart';

class CreateTokenViewContent extends StatefulWidget {
  const CreateTokenViewContent({super.key, this.onCancel, this.onSubmit});

  final void Function()? onCancel;
  final void Function()? onSubmit;

  @override
  State<CreateTokenViewContent> createState() => _CreateTokenViewContentState();
}

class _CreateTokenViewContentState extends State<CreateTokenViewContent> {
  final Api api = Api();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController permissionsController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  bool _loading = false;
  List<int> selectedPermissions = [];
  bool showPassword = false;
  int selectedUser = -1;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<DataModel>(context).get(WhichData.users);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: CreateSideSheet(
        onCancel: widget.onCancel,
        onSubmit: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            _handleCreateToken(scaffoldMessenger);
          }
        },
        title: "Create Token",
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: 282,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          autofocus: true,
                          controller: usernameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Username',
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a Username';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreateToken(scaffoldMessenger);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          // password
                          autofocus: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: 'Password',
                            filled: true,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          obscureText: showPassword,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a Password';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreateToken(scaffoldMessenger);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Consumer<DataModel>(
                          builder: (context, data, child) {
                            List<dynamic> userData =
                                data.data[WhichData.users]!.data ?? [];

                            if (userData.isEmpty) return Container();

                            return DropdownMenu(
                              controller: userController,
                              label: const Text("User"),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                              ),
                              menuHeight: 300,
                              enableFilter: true,
                              enableSearch: true,
                              initialSelection: 0,
                              width: 282,
                              dropdownMenuEntries: (userData.isEmpty)
                                  ? []
                                  : userData
                                      .map(
                                        (e) => DropdownMenuEntry(
                                          value: e.id,
                                          label: e.name.fullName,
                                        ),
                                      )
                                      .toList(),
                              onSelected: (value) {
                                selectedUser = value ?? userData[0].id ?? 0;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // checkboxes to select multiple permissions using Permissions.values
                        SizedBox(
                          width: 282,
                          child: Text("Permissions",
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        const Divider(),
                        for (var permission in Permissions.values)
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(permission.name),
                            dense: true,
                            value:
                                selectedPermissions.contains(permission.value),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedPermissions.add(permission.value);
                                } else {
                                  selectedPermissions.remove(permission.value);
                                }
                              });
                            },
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
    );
  }

  void _handleCreateToken(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    Object body = {
      "username": usernameController.text,
      "password": passwordController.text,
      "user_id": selectedUser,
      "permissions": selectedPermissions,
    };

    // call the api
    final response = await api.post("/token/create", body);

    // log the response
    debugPrint(response.toString());

    // show a snackbar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(response['message']),
      ),
    );

    if (response['code'] == 200) {
      // Close Side Sheet
      widget.onSubmit!();

      _loading = false;

      if (!mounted) return;

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(whichData: WhichData.tokens);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}
