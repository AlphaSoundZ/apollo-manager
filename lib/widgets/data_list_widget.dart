import 'package:flutter/material.dart';
import 'list/list_tile_widget.dart';
import '../classes/api.dart';
import '../enums/which_data.dart';
import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/class_model.dart';
import '../models/usercard_model.dart';

class DataList extends StatefulWidget {
  const DataList({
    super.key,
    required this.whichData,
    this.selectedIndex,
    this.onSelected,
  });

  final WhichData whichData;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();

    // get data
    Api api = Api();
    api.fetchData(widget.whichData).then(
          (body) => {
            setState(
              () {
                data = body;
              },
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8.0),
        ...List.generate(
          data.length,
          (index) {
            return _createWidget(index);
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _createWidget(int index) {
    dynamic rowData;
    // create widget based on whichData type

    switch (widget.whichData) {
      case WhichData.users:
        rowData = data[index] as User;
        break;
      case WhichData.devices:
        rowData = data[index] as Device;
        break;
      case WhichData.classes:
        rowData = data[index] as ClassModel;
        break;
      case WhichData.usercards:
        rowData = data[index] as Usercard;
        break;
    }

    return DataListTile(
      content: rowData.content,
      isSelected: widget.selectedIndex == index,
      onSelected: widget.onSelected != null
          ? () {
              widget.onSelected!(index);
            }
          : null,
    );
  }
}
