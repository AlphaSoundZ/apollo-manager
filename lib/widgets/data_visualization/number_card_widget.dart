import 'package:flutter/material.dart';
import 'dual_tone_card_widget.dart';

class NumberCard extends StatefulWidget {
  const NumberCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.number});

  final String title;
  final String subTitle;
  final String number;

  @override
  State<NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends State<NumberCard> {
  @override
  Widget build(BuildContext context) {
    return DualToneCard(
        content: Center(
          child: Text(widget.number,
              style: TextStyle(
                fontSize: 48,
                // fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )),
        ),
        title: widget.title,
        subTitle: widget.subTitle);
  }
}
