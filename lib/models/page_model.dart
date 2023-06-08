import 'package:flutter/material.dart' hide Page, LicensePage;

class PageModel {
  PageModel({
    required this.label,
    required this.icon,
    required this.widget,
  });

  String label;
  IconData icon;
  Widget widget;

  @override
  String toString() {
    return 'PageModel{label: $label, icon: $icon}';
  }
}
