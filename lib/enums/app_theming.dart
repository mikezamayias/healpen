import 'package:flutter/material.dart';

enum ThemeColor {
  teal(
    color: Color(0xFFA9D6E5),
    name: 'Teal',
  ),
  blue(
    color: Color(0xFFA8D1F0),
    name: 'Blue',
  ),
  green(
    color: Color(0xFFA4D4C9),
    name: 'Green',
  );

  const ThemeColor({required this.color, required this.name});

  final Color color;
  final String name;
}

enum ThemeAppearance {
  system,
  light,
  dark,
}
