import 'package:apollo_manager/services/api.dart';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:apollo_manager/views/action_views/edit_sidesheet_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class EditUserViewContent extends StatefulWidget {
  const EditUserViewContent(
      {super.key, required this.id, this.onCancel, this.onSubmit});

  final int id;
  final void Function()? onCancel;
  final void Function()? onSubmit;

  @override
  State<EditUserViewContent> createState() => _EditUserViewContentState();
}

class _EditUserViewContentState extends State<EditUserViewContent> {
  final Api api = Api();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  bool _loading = false;
  int selectedClass = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<DataModel>(context).get(WhichData.classes);
  }

  @override
  Widget build(BuildContext context) {
    User user =
        Provider.of<DataModel>(context).getById(WhichData.users, widget.id);

    // set values
    firstnameController.text = user.name.firstname;
    lastnameController.text = user.name.lastname;
    // set class id and text
    classController.text = user.class_.name;
    selectedClass = user.class_.id ?? 0;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: EditSideSheet(
        onCancel: widget.onCancel,
        onSave: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            _handleUpdateUser(scaffoldMessenger);
          }
        },
        onDelete: () {},
        title: "Edit User",
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

                              _handleUpdateUser(scaffoldMessenger);
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

                              _handleUpdateUser(scaffoldMessenger);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Consumer<DataModel>(
                          builder: (context, data, child) {
                            List<dynamic> classData =
                                data.data[WhichData.classes];

                            if (classData.isEmpty) return Container();

                            return DropdownMenu(
                              controller: classController,
                              label: const Text("Class"),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                              ),
                              initialSelection: 0,
                              width: 282,
                              dropdownMenuEntries:
                                  (data.data[WhichData.classes].isEmpty)
                                      ? []
                                      : classData
                                          .map(
                                            (e) => DropdownMenuEntry(
                                              value: e.id,
                                              label: e.name,
                                            ),
                                          )
                                          .toList(),
                              onSelected: (value) {
                                selectedClass = value ??
                                    data.data[WhichData.classes][0].id ??
                                    0;
                              },
                            );
                          },
                        )
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

  void _handleUpdateUser(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    Object body = {
      "values": {
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
        "class_id": selectedClass,
      },
      "id": widget.id,
    };

    // call the api
    final response = await api.patch("/user/change", body);

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

      // prevent usage of context if widget is not mounted
      if (!mounted) return;

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(dataType: WhichData.users);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}