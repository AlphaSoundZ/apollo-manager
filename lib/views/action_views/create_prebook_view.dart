import 'package:apollo_manager/services/api.dart';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_sidesheet_view.dart';

class CreatePrebookViewContent extends StatefulWidget {
  const CreatePrebookViewContent({super.key, this.onCancel, this.onSubmit});

  final void Function()? onCancel;
  final void Function()? onSubmit;

  @override
  State<CreatePrebookViewContent> createState() =>
      _CreatePrebookViewContentState();
}

class _CreatePrebookViewContentState extends State<CreatePrebookViewContent> {
  final Api api = Api();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController dateTextFieldController = TextEditingController(
    text: DateTime.now().add(const Duration(days: 1)).toString().split(' ')[0],
  );

  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController endTimeController = TextEditingController();

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  DateTime selectedDate = DateTime.now().add(
    const Duration(days: 1),
  );

  // start time should be 0 O'clock
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 1, minute: 0);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 14)),
      fieldHintText: "mm/dd/yyyy",
      selectableDayPredicate: (DateTime val) =>
          val.weekday != 6 && val.weekday != 7,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );

    _setTimes(startTime: picked);
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

    _setTimes(endTime: picked);
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

            _handleCreatePrebook(scaffoldMessenger);
          }
        },
        title: "Make a Reservation",
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
                        // date picker
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a date';
                            }
                            // today but with time set to 0 O'clock
                            DateTime today = DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);
                            try {
                              if (DateTime.parse(value).isBefore(
                                  today.add(const Duration(days: 1)))) {
                                return 'Please enter a date in the future';
                              }

                              if (DateTime.parse(value).isAfter(
                                  today.add(const Duration(days: 14)))) {
                                return 'Please enter a date within 14 days';
                              }

                              return null;
                            } on FormatException catch (_) {
                              return 'Please enter a valid date';
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreatePrebook(scaffoldMessenger);
                            }
                          },
                          controller: dateTextFieldController,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            labelText: 'Date',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  _selectDate(context).then((value) =>
                                      dateTextFieldController.text =
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0]);
                                },
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // start time picker
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a time';
                            }

                            if (!isValidTime(value)) {
                              return 'Please enter a valid time';
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreatePrebook(scaffoldMessenger);
                            }
                          },
                          controller: startTimeController,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            labelText: 'Start time',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  _selectStartTime(context).then(
                                    (value) => startTimeController.text =
                                        selectedStartTime.format(context),
                                  );
                                },
                                icon: const Icon(
                                  Icons.access_time,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // end time picker
                        TextFormField(
                          onChanged: (value) {
                            // Implement the same as in _selectStartTime (put the stuff in a function and call it here and in _selectStartTime)
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a time';
                            }

                            if (!isValidTime(value)) {
                              return 'Please enter a valid time';
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreatePrebook(scaffoldMessenger);
                            }
                          },
                          controller: endTimeController,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: true,
                            labelText: 'End time',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  _selectEndTime(context).then(
                                    (value) => endTimeController.text =
                                        selectedEndTime.format(context),
                                  );
                                },
                                icon: const Icon(
                                  Icons.access_time,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Amount of devices',
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim() == "") {
                              return 'Please enter a number';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'This is not a number';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _handleCreatePrebook(scaffoldMessenger);
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

  bool isValidTime(String input) {
    final RegExp timeRegex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return timeRegex.hasMatch(input);
  }

  void _handleCreatePrebook(ScaffoldMessengerState scaffoldMessenger) async {
    // Show the loading indicator
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    Object body = {
      "amount": amountController.text,
      "begin": DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedStartTime.hour,
        selectedStartTime.minute,
      ).toIso8601String(),
      "end": DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedEndTime.hour,
        selectedEndTime.minute,
      ).toIso8601String(),
    };

    // call the api
    final response = await api.post("/prebook/create", body);

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

      amountController.text = "";

      _loading = false;

      if (!mounted) {
        return;
      }

      // Update Provider Data
      Provider.of<DataModel>(context, listen: false)
          .updateData(whichData: WhichData.prebook);
    } else {
      // Pop the dialog
      setState(() {
        _loading = false;
      });
    }
  }

  void _setTimes({TimeOfDay? startTime, TimeOfDay? endTime}) {
    if (startTime != null && endTime != null) {
      setState(() {
        selectedStartTime = startTime;
        selectedEndTime = endTime;
      });
      return;
    }

    if (startTime != null && startTime != selectedStartTime) {
      // if start time is changed
      int newHour =
          selectedEndTime.hour + (startTime.hour - selectedStartTime.hour);
      int newMinute = selectedEndTime.minute +
          (startTime.minute - selectedStartTime.minute);

      newHour += newMinute ~/ 60;
      newMinute = newMinute % 60;

      if (newHour > 23) {
        newHour = 23;
        newMinute = 59;
      }

      setState(() {
        selectedEndTime = TimeOfDay(
          hour: newHour,
          minute: newMinute,
        );

        selectedStartTime = startTime;

        startTimeController.text = selectedStartTime.format(context);
        endTimeController.text = selectedEndTime.format(context);
      });
    }

    if (endTime != null && endTime != selectedEndTime) {
      // if end time is changed
      if (endTime.hour < selectedStartTime.hour ||
          (endTime.hour == selectedStartTime.hour &&
              endTime.minute < selectedStartTime.minute)) {
        // if start time is before start time, change start time so that the offset remains the same
        int newHour =
            selectedStartTime.hour - (selectedEndTime.hour - endTime.hour);
        int newMinute = selectedStartTime.minute -
            (selectedEndTime.minute - endTime.minute);

        newHour -= newHour ~/ 60;
        newMinute = newMinute % 60;

        if (newHour < 0) {
          newHour = 0;
          newMinute = 0;
        }

        setState(() {
          selectedStartTime = TimeOfDay(
            hour: newHour,
            minute: newMinute,
          );
          selectedEndTime = endTime;

          startTimeController.text = selectedStartTime.format(context);
          endTimeController.text = selectedEndTime.format(context);
        });
      } else {
        setState(() {
          selectedEndTime = endTime;

          endTimeController.text = selectedEndTime.format(context);
        });
      }
    }
  }
}
