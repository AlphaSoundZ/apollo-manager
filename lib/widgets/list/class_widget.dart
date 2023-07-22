import 'package:flutter/material.dart';
import '../../models/class_model.dart';

class ClassWidget extends StatefulWidget {
  const ClassWidget({
    super.key,
    required this.class_,
    this.isSelected = false,
    this.isPreview = true,
    this.onSelected,
  });

  final ClassModel class_;
  final bool isSelected;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<ClassWidget> createState() => _ClassWidgetState();
}

class _ClassWidgetState extends State<ClassWidget> {
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
              leading: Text(widget.class_.id.toString()),
              title: Text(widget.class_.name),
              subtitle: const Text("some info"),
            ),
          ],
        ),
      ),
    );
  }
}
