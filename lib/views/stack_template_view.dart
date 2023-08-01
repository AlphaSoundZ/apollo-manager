import 'package:flutter/material.dart';

class StackView extends StatefulWidget {
  const StackView({
    super.key,
    required this.child,
    this.title,
    required this.onPop,
  });

  final Widget child;
  final String? title;
  final Function() onPop;

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
          child: Row(
            children: [
              Text(
                widget.title ?? "",
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
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
