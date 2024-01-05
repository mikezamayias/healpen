import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';
import 'theme_components/list_tile_theme.dart';
import 'theme_components/text_theme_data.dart';

ThemeData blueprintTheme(ColorScheme colorScheme) => ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
      colorScheme: colorScheme,
      textTheme: textThemeData,
      // cardColor: colorScheme.primary,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: colorScheme.primary,
      ),
      // scaffoldBackgroundColor: colorScheme.background,
      scaffoldBackgroundColor: Colors.transparent,
      listTileTheme: listTileTheme,
      appBarTheme: AppBarTheme(
        elevation: elevation,
        centerTitle: true,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(gap * 2),
            ),
          ),
          enableFeedback: true,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        contentTextStyle: textThemeData.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.secondary,
        actionBackgroundColor: colorScheme.onSecondary,
        actionTextColor: colorScheme.primary,
        insetPadding: EdgeInsets.zero,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearMinHeight: 6 * unit,
        color: colorScheme.surface,
        refreshBackgroundColor: colorScheme.surface,
        circularTrackColor: colorScheme.primary,
        linearTrackColor: colorScheme.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: colorScheme.onPrimaryContainer,
        unselectedItemColor: colorScheme.outline,
        selectedLabelStyle: textThemeData.bodyLarge!.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: textThemeData.bodyLarge!.copyWith(
          color: colorScheme.outline,
          fontWeight: FontWeight.w500,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer);
          }
          return IconThemeData(color: colorScheme.outline);
        }),
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return textThemeData.bodyLarge!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            );
          }
          return textThemeData.bodyLarge!.copyWith(
            color: colorScheme.outline,
            fontWeight: FontWeight.bold,
          );
        }),
        indicatorShape: ShapeBorder.lerp(
          // make it circle
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          // make it rectangle
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: gap),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          animationDuration: standardDuration,
          side: MaterialStateProperty.all(
            BorderSide(
              width: 3 * unit,
              color: colorScheme.primary,
            ),
          ),
          enableFeedback: true,
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return colorScheme.primary;
              }
              return colorScheme.secondaryContainer;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return colorScheme.onPrimary;
              }
              return colorScheme.onSurface;
            },
          ),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return textThemeData.bodyMedium!.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                );
              }
              return textThemeData.bodyMedium!.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              );
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius - gap),
            ),
          ),
        ),
      ),
    );
