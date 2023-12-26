import 'package:flutter/material.dart' hide LicensePage, Page;

typedef TitleGenerator = String Function(String? userName);

class PageModel {
  PageModel({
    required this.titleGenerator,
    required this.label,
    required this.icon,
    required this.widget,
  });

  TitleGenerator titleGenerator;
  String label;
  IconData icon;
  Widget widget;

  @override
  String toString() {
    return 'PageModel{title: $titleGenerator, label: $label, icon: $icon}';
  }
}
