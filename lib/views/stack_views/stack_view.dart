import 'package:flutter/material.dart';
import '../../models/stack_view_model.dart';

// Creates a stack view for the view-stack, only needed if you want to use the view-stack (the main view (for example: /data) is not a stack view, because it is on the bottom of the stack, and it is not a sub-view of another view, so it can't be popped)
class StackView extends StatefulWidget {
  const StackView(
      {super.key, this.onPop, this.onEdit, required this.stackViewModel});

  final Function()? onPop;
  final Function()? onEdit;
  final StackViewModel stackViewModel;

  @override
  State<StackView> createState() => StackViewState();
}

class StackViewState extends State<StackView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.onPop != null) ...[
                IconButton(
                  onPressed: () {
                    widget.onPop!();
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 25,
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
              if (widget.onPop == null)
                const SizedBox(
                  width: 8,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stackViewModel.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    widget.stackViewModel.subTitle ?? "",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const Spacer(),
              if (widget.onEdit != null)
                IconButton.filledTonal(
                  onPressed: () {
                    widget.onEdit!();
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
              // subtitle
            ],
          ),
        ),
        Expanded(child: widget.stackViewModel.content),
      ],
    );
  }
}
