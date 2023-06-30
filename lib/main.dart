import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'enums/app_theming.dart';
import 'login_view_wrapper.dart';
import 'providers/settings_providers.dart';
import 'services/firebase_service.dart';
import 'themes/blueprint_theme.dart';
import 'utils/helper_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  Magic.instance = Magic('pk_live_0C5A55F503F795D9');

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
              log(
                '${context.theme.scaffoldBackgroundColor}',
                name: 'scaffoldBackgroundColor',
              );
              var lightTheme = blueprintTheme(
                ColorScheme.fromSeed(
                  seedColor: ref.watch(appColorProvider).color,
                  brightness: Brightness.light,
                ),
              );
              var darkTheme = blueprintTheme(
                ColorScheme.fromSeed(
                  seedColor: ref.watch(appColorProvider).color,
                  brightness: Brightness.dark,
                ),
              );
              return Container(
                color: context.theme.scaffoldBackgroundColor,
                child: SafeArea(
                  child: MaterialApp(
                    title: 'Healpen',
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme,
                    darkTheme: darkTheme,
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
                    home: const LoginViewWrapper(),
                    // home: FutureBuilder(
                    //   future: Magic.instance.user.isLoggedIn(),
                    //   builder: (
                    //     BuildContext context,
                    //     AsyncSnapshot<bool> userIsLoggedInSnapshot,
                    //   ) {
                    //     log(
                    //       '${userIsLoggedInSnapshot.data}',
                    //       name: 'main.dart:FutureBuilder',
                    //     );
                    //     // return switch (userIsLoggedInSnapshot.data) {
                    //     //   false => const Healpen(),
                    //     //   _ => const LoginView(),
                    //     // };
                    //     // return switch (userIsLoggedInSnapshot.connectionState) {
                    //     //   ConnectionState.none => const LoginView(),
                    //     //   ConnectionState.waiting => const LoginView(),
                    //     //   ConnectionState.active => const LoginView(),
                    //     //   ConnectionState.done => switch (
                    //     //         userIsLoggedInSnapshot.data) {
                    //     //       true => const Healpen(),
                    //     //       _ => const LoginView(),
                    //     //     },
                    //     // };
                    //   },
                    // ),
                    // home: FirebaseAuth.instance.currentUser == null
                    //     ? const AuthView()
                    //     // ? EmailLinkSignInScreen(
                    //     //     provider: ref
                    //     //         .watch(CustomAuthProvider().emailLinkAuthProvider),
                    //     //   )
                    //     : const Healpen(),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
