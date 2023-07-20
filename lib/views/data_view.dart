import 'package:flutter/material.dart';

import '../classes/api.dart';
import '../models/user_model.dart';
import '../widgets/data_list_widget.dart';

class DataView extends StatefulWidget {
  const DataView({
    super.key,
  });

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<User> data = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // fetch data from api
    Api api = Api();
    _updateData(api);
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
          data: data,
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

  Future<void> _updateData(Api api) async {
    setState(() {
      data = [];
    });

    api.fetchUsers().then((response) {
      debugPrint("Response: ${response?[0].id}");

      setState(() {
        data = response ?? [];
      });
    });
  }
}
