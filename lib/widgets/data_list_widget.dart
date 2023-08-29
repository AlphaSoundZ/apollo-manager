import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/data_model.dart';

class DataList extends StatefulWidget {
  const DataList({
    super.key,
    this.data = const [],
    this.selectedIndex,
    this.onSelected,
    this.onShowDetails,
  });

  final List<dynamic> data;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final Function(int index)? onShowDetails;

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
    return ListView(
      children: [
        const SizedBox(height: 8.0),
        ...List.generate(
          widget.data.length,
          (index) {
            dynamic rowData;
            rowData = widget.data[index].content;
            return Material(
              borderRadius: BorderRadius.circular(56.0 / 2 - 8),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                child: ListTile(
                  onTap: widget.onSelected != null
                      ? () {
                          widget.onShowDetails!(index);
                        }
                      : null,
                  leading: Text(rowData.leading),
                  title: Text(rowData.title),
                  subtitle: Text(rowData.subTitle),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
