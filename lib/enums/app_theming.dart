import 'package:flutter/material.dart';

enum AppColor {
  blue(
    color: Color(0xFF4A90E2),
    name: 'Blue',
  ),
  teal(
    color: Color(0xFF48A9A6),
    name: 'Teal',
  ),
  pastelBlue(
    color: Color(0xFFA8D1F0),
    name: 'Pastel Blue',
  ),
  pastelTeal(
    color: Color(0xFFA4D4C9),
    name: 'Pastel Teal',
  ),
  pastelOcean(
    color: Color(0xFFA9D6E5),
    name: 'Pastel Ocean',
  );

  const AppColor({required this.color, required this.name});

  final Color color;
  final String name;
}

enum Appearance {
  system,
  light,
  dark,
}
