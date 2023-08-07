import 'package:apollo_manager/models/get_response_model.dart';
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
    this.onShowDetails,
  });

  final WhichData whichData;
  final Map<String, dynamic>? params;
  final void Function(int id)? onShowDetails;

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  GetResponseBody responseBody = GetResponseBody.empty();

  int selectedIndex = 0;

  @override
  void initState() {
    if (widget.params != null) {
      Provider.of<DataModel>(context, listen: false).clearSearch();
      responseBody = Provider.of<DataModel>(context, listen: false)
          .search(whichData: widget.whichData, params: widget.params!);
    } else {
      responseBody =
          Provider.of<DataModel>(context, listen: false).get(widget.whichData);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DataView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (widget.params != null) {
      Provider.of<DataModel>(context, listen: false).clearSearch();
      responseBody = Provider.of<DataModel>(context, listen: false)
          .search(whichData: widget.whichData, params: widget.params!);
    } else {
      responseBody =
          Provider.of<DataModel>(context, listen: false).get(widget.whichData);
    }
  }

  @override
  Widget build(BuildContext context) {
    // get data from data model
    if (widget.params != null) {
      responseBody = Provider.of<DataModel>(context)
          .search(whichData: widget.whichData, params: widget.params!);
    } else {
      responseBody = Provider.of<DataModel>(context).get(widget.whichData);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DataList(
        data: responseBody.data,
        selectedIndex: selectedIndex,
        onSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        onShowDetails: (index) {
          int id = responseBody.data[index].id;
          if (widget.onShowDetails != null) {
            widget.onShowDetails!(id);
          }
        },
      ),
    );
  }
}
