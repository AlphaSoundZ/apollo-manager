import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../widgets/data_list_widget.dart';

class DataView extends StatefulWidget {
  const DataView({
    super.key,
    required this.whichData,
  });

  final WhichData whichData;

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<dynamic> data = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DataList(
        whichData: widget.whichData,
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
