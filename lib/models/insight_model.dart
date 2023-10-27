import 'package:flutter/material.dart';

class InsightModel {
  final String title;
  final String explanation;
  final Widget widget;

  const InsightModel({
    required this.title,
    required this.explanation,
    required this.widget,
  });

  @override
  String toString() {
    return 'InsightModel{title: $title, explanation: $explanation}';
  }
}
