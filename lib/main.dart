import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/app_theming_controller.dart';
import 'enums/app_theming.dart';
import 'models/app_theming_model.dart';
import 'services/firebase_service.dart';
import 'utils/helper_functions.dart';
import 'views/auth/auth_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  await AppColorController.instance.loadColor();
  await AppearanceController.instance.loadAppearance();

  runApp(
    ProviderScope(
      overrides: [
        AppColorController.instance.appColorControllerProvider.overrideWith(
          (ref) => AppColorController.instance,
        ),
        AppearanceController.instance.appearanceControllerProvider.overrideWith(
          (ref) => AppearanceController.instance,
        ),
      ],
      child: ResponsiveSizer(
        builder: (
          BuildContext context,
          Orientation orientation,
          ScreenType screenType,
        ) {
          return Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              // Get the current values from the controllers
              AppColorModel appColorModel = ref.watch(
                  AppColorController.instance.appColorControllerProvider);
              AppearanceModel appearanceModel = ref.watch(
                  AppearanceController.instance.appearanceControllerProvider);

              // Use the values in your theme
              ThemeData theme = getTheme(
                appColorModel.appColor,
                appearanceModel.appearance == Appearance.dark
                    ? Brightness.dark
                    : Brightness.light,
              );
              return MaterialApp(
                title: 'Healpen',
                debugShowCheckedModeBanner: false,
                color: appColorModel.appColor.color,
                theme: theme,
                home: const AuthView(),
              );
            },
          );
        },
      ),
    ),
  );
}
