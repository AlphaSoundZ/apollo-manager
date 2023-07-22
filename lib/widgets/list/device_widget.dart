import 'package:flutter/material.dart';
import '../../models/device_model.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({
    super.key,
    required this.device,
    this.isSelected = false,
    this.isPreview = true,
    this.onSelected,
  });

  final Device device;
  final bool isSelected;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
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
              leading: Text(widget.device.id.toString()),
              title: Text(widget.device.uid),
              subtitle: const Text("some info"),
            ),
          ],
        ),
      ),
    );
  }
}
