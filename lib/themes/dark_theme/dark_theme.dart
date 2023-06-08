import 'package:flutter/material.dart';

import '../blueprint_theme.dart';
import '../theme_color_schemes/dark_theme_color_scheme.dart';

ThemeData darkTheme(ColorScheme? colorScheme) =>
    blueprintTheme(colorScheme ?? darkThemeColorScheme);
