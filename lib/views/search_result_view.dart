import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../widgets/data_list_widget.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({
    super.key,
    required this.whichData,
  });

  final WhichData whichData;

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Center(
        child: Text("Search Results"),
      ),
      // child: DataList(
      //   whichData: widget.whichData,
      //   selectedIndex: selectedIndex,
      //   onSelected: (index) {
      //     setState(() {
      //       selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
