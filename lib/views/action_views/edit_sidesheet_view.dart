import 'package:flutter/material.dart';

// Returns the content of a side sheet used for creating a new data entry
class EditSideSheet extends StatefulWidget {
  const EditSideSheet({
    super.key,
    required this.children,
    this.onSave,
    this.onCancel,
    this.onDelete,
    this.title,
  });

  final List<Widget> children;
  final void Function()? onSave;
  final void Function()? onCancel;
  final void Function()? onDelete;
  final String? title;

  @override
  State<EditSideSheet> createState() => EditSideSheetState();
}

class EditSideSheetState extends State<EditSideSheet> {
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
                onPressed: widget.onSave,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ),
            const Spacer(),
            // delete button
            if (widget.onDelete != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
