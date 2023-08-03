import 'package:flutter/material.dart';
import '../../models/stack_view_model.dart';
import 'stack_template_view.dart';
import 'package:provider/provider.dart';
import '../../models/data_model.dart';
import '../../enums/which_data.dart';

class DetailsView extends StatefulWidget {
  const DetailsView(
      {super.key, required this.id, required this.whichData, this.onPop});

  final int id;
  final WhichData whichData;
  final Function()? onPop;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return StackView(
      stackViewModel: widget.whichData.detailsView(context, widget.id),
      onPop: () {
        if (widget.onPop != null) {
          widget.onPop!();
        }
      },
    );
  }
}
