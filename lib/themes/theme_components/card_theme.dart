import 'package:flutter/material.dart';

import '../../utils/constants.dart';

final CardTheme cardTheme = CardTheme(
  elevation: elevation,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  ),
  clipBehavior: Clip.none,
);
