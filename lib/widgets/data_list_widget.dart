import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import 'list/list_tile_widget.dart';
import '../enums/which_data.dart';

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
    Provider.of<DataModel>(context, listen: false).get(widget.whichData);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get data from data model
    data = Provider.of<DataModel>(context).get(widget.whichData);

    // get consumer for data model
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
    rowData = data[index];
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
