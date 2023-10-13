import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'controllers/emotional_echo_controller.dart';
import 'controllers/healpen/healpen_controller.dart';
import 'controllers/page_controller.dart' as page_controller;
import 'controllers/settings/firestore_preferences_controller.dart';
import 'controllers/settings/preferences_controller.dart';
import 'models/settings/preference_model.dart';
import 'providers/settings_providers.dart';
import 'utils/constants.dart';
import 'utils/helper_functions.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Animate> pages = [
      for (final page in page_controller.PageController().pages)
        page.widget
            .animate()
            .fade(duration: emphasizedDuration, curve: emphasizedCurve),
    ];
    return StreamBuilder(
        stream: FirestorePreferencesController().getPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(
              'StreamBuilder Error: ${snapshot.error}',
              name: '_HealpenWrapperState:StreamBuilder - Error',
            );
          }

          if (snapshot.hasData) {
            List<PreferenceModel> fetchedPreferences = snapshot.data!;
            // log(
            //   'Fetched Preferences: $fetchedPreferences',
            //   name: '_HealpenWrapperState:StreamBuilder - Fetched Preferences',
            // );

            Future.microtask(() {
              Map<String, dynamic> fetchedPreferenceMap = {
                for (var p in fetchedPreferences) p.key: p.value
              };

              for (({PreferenceModel preferenceModel}) preferenceTuple
                  in PreferencesController().preferences) {
                var key = preferenceTuple.preferenceModel.key;
                if (fetchedPreferenceMap.containsKey(key)) {
                  // ref.read(preferenceTuple.provider.notifier).state =
                  //     fetchedPreferenceMap[key];
                  preferenceTuple.preferenceModel.withValue(
                    fetchedPreferenceMap[key],
                  );
                  // log(
                  //   'Updating ${preferenceTuple.preferenceModel.key} '
                  //   'with value: ${fetchedPreferenceMap[key]}',
                  //   name: '_HealpenWrapperState:StreamBuilder - Updating State',
                  // );
                }
              }

              getSystemUIOverlayStyle(
                context.theme,
                ref.watch(themeAppearanceProvider),
              );

              EmotionalEchoController.goodColor =
                  context.theme.colorScheme.primary;
              EmotionalEchoController.badColor =
                  context.theme.colorScheme.error;
              EmotionalEchoController.onGoodColor =
                  context.theme.colorScheme.onPrimary;
              EmotionalEchoController.onBadColor =
                  context.theme.colorScheme.onError;
            });
          }

          return Scaffold(
            body: PageView.builder(
              controller: ref.watch(HealpenController().pageControllerProvider),
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                vibrate(
                    PreferencesController.navigationEnableHapticFeedback.value,
                    () {
                  ref
                      .watch(
                          HealpenController().currentPageIndexProvider.notifier)
                      .state = value;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  duration: slightlyLongEmphasizedDuration,
                  curve: emphasizedCurve,
                  opacity:
                      ref.watch(HealpenController().currentPageIndexProvider) ==
                              index
                          ? 1
                          : 0,
                  child: pages.elementAt(index),
                );
              },
            ),
            bottomNavigationBar: const CustomBottomNavigationBar(),
          );
        });
  }
}
