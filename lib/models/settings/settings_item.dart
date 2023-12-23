import 'package:flutter/material.dart';

class SettingsItem {
  SettingsItem({
    required this.title,
    required this.description,
    required this.iconData,
    required this.widget,
  });

  String title;
  String description;
  IconData iconData;
  Widget widget;
}