import 'package:flutter/material.dart';
import '../../models/stack_view_model.dart';

class StackView extends StatefulWidget {
  const StackView(
      {super.key, required this.onPop, required this.stackViewModel});

  final Function() onPop;
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
              IconButton(
                onPressed: widget.onPop,
                icon: const Icon(Icons.arrow_back),
                iconSize: 25,
              ),
              const SizedBox(
                width: 12,
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
              IconButton.filledTonal(
                onPressed: () {},
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
