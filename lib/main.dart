import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide LoginView;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/app_theming_controller.dart';
import 'enums/app_theming.dart';
import 'firebase_options.dart';
import 'healpen.dart';
import 'models/app_theming_model.dart';
import 'utils/constants.dart';
import 'utils/helper_functions.dart';
import 'views/blueprint/blueprint_view.dart';
import 'widgets/app_bar.dart';
import 'widgets/custom_list_tile/custom_list_tile.dart';
import 'widgets/loading_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics.instance;

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    // androidProvider: AndroidProvider.playIntegrity,
  );

  var emailLinkAuthProvider = EmailLinkAuthProvider(
    actionCodeSettings: ActionCodeSettings(
      url: 'https://healpen.page.link',
      // url: 'https://healpen.page.link/email-link-sign-in',
      handleCodeInApp: true,
      androidMinimumVersion: '1',
      androidPackageName: 'com.mikezamayias.healpen',
      iOSBundleId: 'com.mikezamayias.healpen',
    ),
  );

  FirebaseUIAuth.configureProviders([
    emailLinkAuthProvider,
  ]);

  // Adds Firebase Crashlytics to the app
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
                home: AuthFlowBuilder<EmailLinkAuthController>(
                  provider: emailLinkAuthProvider,
                  builder: (context, state, ctrl, child) {
                    if (state is SignedIn) {
                      return const Healpen();
                    } else {
                      return BlueprintView(
                        appBar: const AppBar(
                          pathNames: ['Passwordless Sign In'],
                        ),
                        body: switch (state) {
                          Uninitialized() => CustomListTile(
                              cornerRadius: radius,
                              contentPadding: const EdgeInsets.all(12),
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign in using only your email.',
                                    style: context.theme.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              subtitle: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: context.theme.textTheme.titleLarge,
                                ),
                                style: context.theme.textTheme.titleLarge,
                                onSubmitted: (String email) {
                                  ctrl.sendLink(email);
                                },
                              ),
                            ),
                          AwaitingDynamicLink() => const LoadingTile(
                              durationTitle: 'Sending link to your email',
                            ),
                          AuthFailed() => CustomListTile(
                              cornerRadius: radius,
                              contentPadding: const EdgeInsets.all(12),
                              backgroundColor: context.theme.colorScheme.error,
                              textColor: context.theme.colorScheme.onError,
                              titleString: 'Something went wrong!',
                              subtitle: ErrorText(exception: state.exception),
                            ),
                          _ => CustomListTile(
                              cornerRadius: radius,
                              contentPadding: const EdgeInsets.all(12),
                              titleString: 'Unknown state',
                              subtitleString: '${state.runtimeType}',
                            )
                        },
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
