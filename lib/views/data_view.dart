import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums/which_data.dart';
import '../models/data_model.dart';
import '../widgets/data_list_widget.dart';

class DataView extends StatefulWidget {
  const DataView({
    super.key,
    required this.whichData,
    this.params,
  });

  final WhichData whichData;
  final Map<String, dynamic>? params;

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<dynamic> data = [];

  int selectedIndex = 0;

  @override
  void initState() {
    if (widget.params != null) {
      data = Provider.of<DataModel>(context, listen: false)
          .search(whichData: widget.whichData, params: widget.params!);
    } else {
      data =
          Provider.of<DataModel>(context, listen: false).get(widget.whichData);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get data from data model
    if (widget.params != null) {
      data = Provider.of<DataModel>(context)
          .search(whichData: widget.whichData, params: widget.params!);
    } else {
      data = Provider.of<DataModel>(context).get(widget.whichData);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DataList(
        data: data,
        selectedIndex: selectedIndex,
        onSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
