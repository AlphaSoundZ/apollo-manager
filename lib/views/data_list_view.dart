import 'package:flutter/material.dart';

import '../widgets/user_widget.dart';
import '../widgets/search_bar_widget.dart' as search_bar;
import '../classes/api.dart';
import '../models/user_model.dart';

class DataListView extends StatefulWidget {
  const DataListView({
    super.key,
    this.selectedIndex,
    this.onSelected,
  });

  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<DataListView> createState() => _DataListViewState();
}

class _DataListViewState extends State<DataListView> {
  List<User> data = [];

  @override
  void initState() {
    super.initState();

    // fetch data from api
    Api api = Api();
    api.fetchUsers().then((response) {
      debugPrint("Response: ${response?[0].id}");
      setState(() {
        data = response ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const search_bar.SearchBar(),
            const SizedBox(height: 8),
            ...List.generate(
              data.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: UserWidget(
                    user: data[index],
                    onSelected: widget.onSelected !=
                            null // check if callback is provided
                        ? () {
                            widget.onSelected!(index);
                          }
                        : null,
                    isSelected: widget.selectedIndex == index,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
