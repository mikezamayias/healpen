import 'package:flutter/material.dart';

import '../blueprint_theme.dart';
import '../theme_color_schemes/light_theme_color_scheme.dart';

ThemeData lightTheme(ColorScheme? colorScheme) =>
    blueprintTheme(colorScheme ?? lightThemeColorScheme);
