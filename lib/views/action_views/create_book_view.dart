import 'package:apollo_manager/services/api.dart';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'create_sidesheet_view.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class CreateBookViewContent extends StatefulWidget {
  const CreateBookViewContent({super.key, this.onCancel, this.onSubmit});

  final void Function()? onCancel;
  final void Function()? onSubmit;

  @override
  State<CreateBookViewContent> createState() => _CreateBookViewContentState();
}

class _CreateBookViewContentState extends State<CreateBookViewContent> {
  final Api api = Api();

  final TextEditingController uidController = TextEditingController();

  final TextEditingController dateTextFieldController = TextEditingController(
    text: DateTime.now().add(const Duration(days: 1)).toString().split(' ')[0],
  );

  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController endTimeController = TextEditingController();

  // ignore: unused_field
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  String uid = "Waiting for UID";
  String usercardUid = "";

  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();

    _storage.getString('usercardUid').then((value) {
      // get the the usercard provider
      Provider.of<DataModel>(context, listen: false)
          .get(context, WhichData.usercards);

      setState(() {
        usercardUid = value;
      });
    });

    startRFIDScan();
  }

  Future<void> startRFIDScan() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability == NFCAvailability.available) {
      try {
        var tag = await FlutterNfcKit.poll();
        setState(() {
          uid = tag.id;
          uidController.text = uid;
        });
        await FlutterNfcKit.finish();
      } on PlatformException catch (e) {
        setState(() {
          uid = e.message!;
        });
      }
    } else {
      setState(() {
        uid = "NFC not available";
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

            _handleBooking(scaffoldMessenger);
          }
        },
        title: "Make a Booking",
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
                        const Text(
                          'RFID UID:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          uid,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        // date picker
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
                              return 'Please enter a uid';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleBooking(scaffoldMessenger);
                            }
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

  void _handleBooking(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    if (usercardUid == "") {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("You need to register a usercard in order to book"),
        ),
      );
      return;
    }

    Object body = {
      // TODO: change API, so that you can add a third param (bool) to the body, so it will automatically return a device if it's lent out, and book it when it's available
      "uid_1": usercardUid,
      "uid_2": uidController.text,
    };

    // call the api
    final response = await api.post("/booking", body);

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

      // Clear the text fields
      setState(() {
        uid = "Waiting for UID";
        uidController.text = "";
      });

      _loading = false;

      if (!mounted) {
        return;
      }

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(context, whichData: WhichData.bookings);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }
}
