import 'package:flutter/material.dart';
import '../models/user_model.dart';

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
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.08),
    _colorScheme.surface,
  );

  Color get _surfaceColor {
    if (!widget.isPreview) {
      return _colorScheme.surface;
    }
    if (widget.isSelected) {
      return _colorScheme.primaryContainer;
    }
    return unselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelected,
      child: Card(
        elevation: 0,
        color: _surfaceColor,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Text(widget.user.id.toString()),
              title: Text(widget.user.name.fullName),
              subtitle: Text("Klasse: ${widget.user.className}"),
            ),
          ],
        ),
      ),
    );
  }
}
