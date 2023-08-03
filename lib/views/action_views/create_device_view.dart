import 'package:apollo_manager/services/api.dart';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_template_view.dart';

class CreateDeviceViewContent extends StatefulWidget {
  const CreateDeviceViewContent({super.key, this.onCancel, this.onSubmit});

  final void Function()? onCancel;
  final void Function()? onSubmit;

  @override
  State<CreateDeviceViewContent> createState() =>
      _CreateDeviceViewContentState();
}

class _CreateDeviceViewContentState extends State<CreateDeviceViewContent> {
  final Api api = Api();

  final TextEditingController uidController = TextEditingController();
  final TextEditingController deviceTypeController = TextEditingController();

  bool _loading = false;
  int selectedDeviceType = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<DataModel>(context).get(WhichData.deviceTypes);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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
        title: "Create Device",
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
                          controller: uidController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'UID',
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a UID';
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
                            List<dynamic> deviceTypeData =
                                data.data[WhichData.deviceTypes];

                            if (deviceTypeData.isEmpty) return Container();

                            return DropdownMenu(
                              controller: deviceTypeController,
                              label: const Text("Device Type"),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                              ),
                              initialSelection: 0,
                              width: 282,
                              dropdownMenuEntries:
                                  (data.data[WhichData.deviceTypes].isEmpty)
                                      ? []
                                      : deviceTypeData
                                          .map(
                                            (e) => DropdownMenuEntry(
                                              value: e.id,
                                              label: e.name,
                                            ),
                                          )
                                          .toList(),
                              onSelected: (value) {
                                selectedDeviceType = value ??
                                    data.data[WhichData.deviceTypes][0].id ??
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

  void _handleCreateUser(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    Object body = {
      "uid": uidController.text,
      "type": selectedDeviceType,
    };

    // call the api
    final response = await api.post("/device/create", body);

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

      uidController.text = "";

      _loading = false;

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(dataType: WhichData.devices);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}
