import 'package:flutter/material.dart';
import '../../models/list_tile_content_model.dart';

class DataListTile extends StatefulWidget {
  const DataListTile({
    super.key,
    required this.content,
    this.isSelected = false,
    this.isPreview = true,
    this.onSelected,
  });

  final ListTileContent content;
  final bool isSelected;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<DataListTile> createState() => _DataListTileState();
}

class _DataListTileState extends State<DataListTile> {
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
              leading: Text(widget.content.leading),
              title: Text(widget.content.title),
              subtitle: Text(widget.content.subTitle),
            ),
          ],
        ),
      ),
    );
  }
}
