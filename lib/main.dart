import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'enums/app_theming.dart';
import 'healpen.dart';
import 'providers/settings_providers.dart';
import 'services/firebase_service.dart';
import 'themes/blueprint_theme.dart';
import 'utils/helper_functions.dart';
import 'views/auth/auth_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  runApp(
    ProviderScope(
      child: ResponsiveSizer(
        builder: (
          BuildContext context,
          Orientation orientation,
          ScreenType screenType,
        ) {
          return Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              readAppearance(ref);
              readAppColor(ref);
              return MaterialApp(
                title: 'Healpen',
                debugShowCheckedModeBanner: false,
                theme: blueprintTheme(
                  ColorScheme.fromSeed(
                    seedColor: ref.watch(appColorProvider).color,
                    brightness: Brightness.light,
                  ),
                ),
                darkTheme: blueprintTheme(
                  ColorScheme.fromSeed(
                    seedColor: ref.watch(appColorProvider).color,
                    brightness: Brightness.dark,
                  ),
                ),
                themeMode: switch (ref.watch(appearanceProvider)) {
                  Appearance.system => ThemeMode.system,
                  Appearance.light => ThemeMode.light,
                  Appearance.dark => ThemeMode.dark,
                },
                // home: AnnotatedRegion<SystemUiOverlayStyle>(
                //   value: SystemUiOverlayStyle(
                //     statusBarColor: context.theme.scaffoldBackgroundColor,
                //     statusBarBrightness:
                //         appearanceModel.appearance == Appearance.dark
                //             ? Brightness.dark
                //             : Brightness.light,
                //     statusBarIconBrightness:
                //         appearanceModel.appearance == Appearance.dark
                //             ? Brightness.light
                //             : Brightness.dark,
                //     systemNavigationBarColor:
                //         context.theme.scaffoldBackgroundColor,
                //     systemNavigationBarIconBrightness:
                //         appearanceModel.appearance == Appearance.dark
                //             ? Brightness.light
                //             : Brightness.dark,
                //     systemNavigationBarDividerColor: Colors.transparent,
                //   ),
                //   child: FirebaseAuth.instance.currentUser == null
                //       ? const AuthView()
                //       : const Healpen(),
                home: FirebaseAuth.instance.currentUser == null
                    ? const AuthView()
                    : const Healpen(),
              );
            },
          );
        },
      ),
    ),
  );
}
