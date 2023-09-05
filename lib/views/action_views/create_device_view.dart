import '../../services/api.dart';
import '../../enums/which_data.dart';
import '../../models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_sidesheet_view.dart';

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

  // ignore: unused_field
  bool _loading = false;
  int selectedDeviceType = -1;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<DataModel>(context).get(context, WhichData.deviceTypes);
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

            _handleCreateDevice(scaffoldMessenger);
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
                          autofocus: true,
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

                              _handleCreateDevice(scaffoldMessenger);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Consumer<DataModel>(
                          builder: (context, data, child) {
                            List<dynamic> deviceTypeData =
                                data.data[WhichData.deviceTypes]!.data ?? [];

                            if (deviceTypeData.isEmpty) return Container();

                            return DropdownMenu(
                              controller: deviceTypeController,
                              label: const Text("Device Type"),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                              ),
                              initialSelection: 0,
                              width: 282,
                              dropdownMenuEntries: (deviceTypeData.isEmpty)
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
                                selectedDeviceType =
                                    value ?? deviceTypeData[0].id ?? 0;
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

  void _handleCreateDevice(ScaffoldMessengerState scaffoldMessenger) async {
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

      if (!mounted) return;

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(context, whichData: WhichData.devices);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}
