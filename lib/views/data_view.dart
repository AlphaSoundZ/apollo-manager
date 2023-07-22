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
    final surfaceContainer = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
      Theme.of(context).colorScheme.surface,
    );

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(56.0 / 2),
        color: surfaceContainer,
      ),
      child: Container(
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
      ),
    );
  }
}
