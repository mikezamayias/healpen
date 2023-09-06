import 'package:flutter/material.dart';

enum ThemeColor {
  // blue(
  //   color: Color(0xFF4A90E2),
  //   name: 'Blue',
  // ),
  // teal(
  //   color: Color(0xFF48A9A6),
  //   name: 'Teal',
  // ),
  blue(
    color: Color(0xFFA8D1F0),
    name: 'Blue',
  ),
  green(
    color: Color(0xFFA4D4C9),
    name: 'Green',
  ),
  teal(
    color: Color(0xFFA9D6E5),
    name: 'Teal',
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
