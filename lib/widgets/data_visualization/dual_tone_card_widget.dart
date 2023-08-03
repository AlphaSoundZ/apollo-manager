import 'package:flutter/material.dart';

class DualToneCard extends StatefulWidget {
  const DualToneCard({
    super.key,
    required this.content,
    required this.title,
    required this.subTitle,
  });

  final Widget content;
  final String title;
  final String subTitle;

  @override
  State<DualToneCard> createState() => DualToneCardState();
}

class DualToneCardState extends State<DualToneCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Material(
                  // color elevated
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: widget.content,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      widget.subTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
