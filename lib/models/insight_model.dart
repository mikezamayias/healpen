import 'package:flutter/material.dart';

@Model()
class InsightModel {
  final String title;
  final String explanation;
  final Widget widget;

  const InsightModel({
    required this.title,
    required this.explanation,
    required this.widget,
  });
}
