import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/data_model.dart';
import '../../services/api.dart';
import 'stack_view.dart';
import '../../enums/which_data.dart';

// creates a stack view with the details view of the specified data (contains some navigation and action buttons, used for layout consistency)
class DetailsView extends StatefulWidget {
  const DetailsView({
    super.key,
    required this.id,
    required this.whichData,
    this.onPop,
    this.onEdit,
  });

  final int id;
  final WhichData whichData;
  final Function()? onPop;
  final Function()? onEdit;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return StackView(
        stackViewModel: widget.whichData.detailsView(context, widget.id),
        onEdit: widget.onEdit != null
            ? () {
                widget.onEdit!();
              }
            : null,
        onPop: widget.onPop != null
            ? () {
                widget.onPop!();
              }
            : null,
        onMenuItemSelected: (String item) {
          switch (item) {
            case "delete":
              Api().delete(
                "${widget.whichData.route}/delete",
                {"id": widget.id},
              ).then((value) {
                Provider.of<DataModel>(context, listen: false)
                    .updateData(context, whichData: widget.whichData);

                widget.onPop!();
              });
              break;
            default:
              break;
          }
        });
  }
}
