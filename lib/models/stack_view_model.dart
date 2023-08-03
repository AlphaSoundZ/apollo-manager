import 'package:flutter/material.dart';

class StackViewModel {
  StackViewModel({required this.title, this.subTitle, required this.content});

  final String title;
  final String? subTitle;
  final dynamic content;
}