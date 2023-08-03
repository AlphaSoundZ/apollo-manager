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
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.stackViewModel.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: widget.onPop,
                    icon: const Icon(Icons.close),
                    iconSize: 25,
                  ),
                ],
              ),
              // subtitle
              Text(
                widget.stackViewModel.subTitle ?? "",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Expanded(child: widget.stackViewModel.content),
      ],
    );
  }
}
