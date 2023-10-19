import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveColorComponent {
  /// The name of the shape (as defined in the editor)
  final String shapeName;

  /// The name of the fill (as defined in the editor)
  final String fillName;

  /// The color to update to
  final Color color;

  Shape? shape;
  Fill? fill;

  RiveColorComponent({
    required this.shapeName,
    required this.fillName,
    required this.color,
  });

  @override
  bool operator ==(covariant RiveColorComponent other) {
    if (identical(this, other)) return true;

    return other.fillName == fillName &&
        other.shapeName == shapeName &&
        other.color == color;
  }

  @override
  int get hashCode {
    return fillName.hashCode ^ shapeName.hashCode ^ color.hashCode;
  }
}
