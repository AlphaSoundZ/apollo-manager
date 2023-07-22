import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'list_tile_widget.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({
    super.key,
    required this.user,
    this.isSelected = false,
    this.isPreview = true,
    this.onSelected,
  });

  final User user;
  final bool isSelected;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return DataListTile(
      content: widget.user.content,
      isSelected: widget.isSelected,
      isPreview: widget.isPreview,
      onSelected: () {
        widget.onSelected!();
      },
    );
  }
}
