import '../../services/api.dart';
import '../../enums/which_data.dart';
import '../../models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_sidesheet_view.dart';

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

  // ignore: unused_field
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

    Provider.of<DataModel>(context).get(context, WhichData.classes);
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
                          autofocus: true,
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
                        Consumer<DataModel>(
                          builder: (context, data, child) {
                            List<dynamic> classData =
                                data.data[WhichData.classes]!.data;

                            if (classData.isEmpty) return Container();

                            return DropdownMenu(
                              controller: classController,
                              label: const Text("Class"),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                              ),
                              initialSelection: 0,
                              width: 282,
                              dropdownMenuEntries: (classData.isEmpty)
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
                                selectedClass = value ?? classData[0].id ?? 0;
                              },
                            );
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
      // Close Side Sheet
      widget.onSubmit!();

      _loading = false;

      // prevent usage of context if widget is not mounted
      if (!mounted) return;

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(context, whichData: WhichData.users);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}
