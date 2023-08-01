import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import 'list/list_tile_widget.dart';
import '../enums/which_data.dart';

class DataList extends StatefulWidget {
  const DataList({
    super.key,
    this.data = const [],
    this.selectedIndex,
    this.onSelected,
  });

  final List<dynamic> data;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get consumer for data model
    return ListView(
      children: [
        const SizedBox(height: 8.0),
        ...List.generate(
          widget.data.length,
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
    rowData = widget.data[index];
    // create widget based on whichData type

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
