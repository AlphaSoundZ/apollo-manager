import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/user_widget.dart';

class DataList extends StatefulWidget {
  const DataList({
    super.key,
    required this.data,
    this.selectedIndex,
    this.onSelected,
  });

  final List<User> data;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8.0),
        ...List.generate(
          widget.data.length,
          (index) {
            return UserWidget(
              user: widget.data[index],
              onSelected:
                  widget.onSelected != null // check if callback is provided
                      ? () {
                          widget.onSelected!(index);
                        }
                      : null,
              isSelected: widget.selectedIndex == index,
            );
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
