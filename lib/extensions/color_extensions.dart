import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color applySurfaceTint({
    required Color surfaceTintColor,
    required double elevation,
  }) =>
      ElevationOverlay.applySurfaceTint(
        this,
        surfaceTintColor,
        elevation,
      );
}
