import 'package:apollo_manager/classes/api.dart';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'create_template_view.dart';
import '../../models/class_model.dart';

class CreateUserViewContent extends StatefulWidget {
  const CreateUserViewContent({super.key, this.onCancel, this.onSubmit});

  final void Function()? onCancel;
  final void Function()? onSubmit;

  @override
  State<CreateUserViewContent> createState() => _CreateUserViewContentState();
}

class _CreateUserViewContentState extends State<CreateUserViewContent> {
  final Api api = Api();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

  bool _loading = false;
  int selectedClass = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // class data
    final List<dynamic> classes =
        Provider.of<DataModel>(context).get(WhichData.classes);

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: SideSheetContent(
        onCancel: widget.onCancel,
        onSubmit: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            _handleCreateUser(scaffoldMessenger);
          }
        },
        title: "Create User",
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
                          controller: firstnameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'First name',
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreateUser(scaffoldMessenger);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: lastnameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Surname',
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Surname';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreateUser(scaffoldMessenger);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownMenu(
                          controller: classController,
                          label: const Text("Class"),
                          inputDecorationTheme: const InputDecorationTheme(
                            filled: true,
                          ),
                          initialSelection: 0,
                          width: 282,
                          dropdownMenuEntries: classes
                              .map(
                                (e) => DropdownMenuEntry(
                                  value: e.id,
                                  label: e.name,
                                ),
                              )
                              .toList(),
                          onSelected: (value) {
                            selectedClass = value ?? 0;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                //  if (_loading)
                //     const Align(
                //       alignment: Alignment.topCenter,
                //       child: LinearProgressIndicator(),
                //     ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleCreateUser(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    Object body = {
      "firstname": firstnameController.text,
      "lastname": lastnameController.text,
      "class_id": selectedClass,
    };

    // call the api
    final response = await api.post("/user/create", body);

    // log the response
    debugPrint(response.toString());

    // show a snackbar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(response['message']),
      ),
    );

    if (response['code'] == 200) {
      firstnameController.text = "";
      lastnameController.text = "";

      // Close Side Sheet
      widget.onCancel!();

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(dataType: WhichData.users)
          .then((_) => _loading = false);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}
