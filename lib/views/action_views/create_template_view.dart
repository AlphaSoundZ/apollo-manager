import 'package:flutter/material.dart';

class SideSheetContent extends StatefulWidget {
  const SideSheetContent({
    super.key,
    required this.children,
    this.onSubmit,
    this.onCancel,
    this.title,
  });

  final List<Widget> children;
  final void Function()? onSubmit;
  final void Function()? onCancel;
  final String? title;

  @override
  State<SideSheetContent> createState() => SideSheetContentState();
}

class SideSheetContentState extends State<SideSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.title ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.onCancel,
              icon: const Icon(Icons.close),
              iconSize: 25,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...widget.children,
        const Spacer(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 50),
                ),
                onPressed: widget.onSubmit,
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
