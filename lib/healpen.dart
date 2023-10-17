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

class Healpen extends ConsumerStatefulWidget {
  const Healpen({super.key});

  @override
  ConsumerState<Healpen> createState() => _HealpenState();
}

class _HealpenState extends ConsumerState<Healpen> {
  List<PreferenceModel> _lastFetchedPreferences = [];

  @override
  Widget build(BuildContext context) {
    // Moved pages creation to a separate function
    final pages = _buildPages();

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
          List<PreferenceModel> currentPreferences =
              snapshot.data as List<PreferenceModel>;

          if (_havePreferencesChanged(currentPreferences)) {
            _updatePreferences(currentPreferences);
            _lastFetchedPreferences = currentPreferences;
          }
        }

        _setupGlobalStyles(context);

        return Scaffold(
          body: PageView.builder(
            controller: ref.watch(HealpenController().pageControllerProvider),
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) => _handlePageChange(value),
            itemCount: pages.length,
            itemBuilder: (context, index) => _buildPage(context, index, pages),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }

  List<Animate> _buildPages() {
    return [
      for (final page in page_controller.PageController().pages)
        page.widget
            .animate()
            .fade(duration: emphasizedDuration, curve: emphasizedCurve),
    ];
  }

  void _updatePreferences(List<PreferenceModel> fetchedPreferences) {
    Future.microtask(() {
      // Moved this logic to a separate function
      var fetchedPreferenceMap = {
        for (var p in fetchedPreferences) p.key: p.value
      };

      for (var preferenceTuple in PreferencesController().preferences) {
        var key = preferenceTuple.preferenceModel.key;
        if (fetchedPreferenceMap.containsKey(key)) {
          ref.read(preferenceTuple.provider.notifier).state =
              fetchedPreferenceMap[key];
          log(
            'Updated ${preferenceTuple.preferenceModel.key} '
            'with value: ${fetchedPreferenceMap[key]}',
            name: '_HealpenWrapperState:StreamBuilder - Updating State',
          );
        }
      }
    });
  }

  void _setupGlobalStyles(BuildContext context) {
    // Moved this logic to a separate function
    getSystemUIOverlayStyle(context.theme, ref.watch(themeAppearanceProvider));

    EmotionalEchoController.goodColor = context.theme.colorScheme.primary;
    EmotionalEchoController.badColor = context.theme.colorScheme.error;
    EmotionalEchoController.onGoodColor = context.theme.colorScheme.onPrimary;
    EmotionalEchoController.onBadColor = context.theme.colorScheme.onError;
  }

  void _handlePageChange(int value) {
    // Moved this logic to a separate function
    vibrate(                  ref.watch(navigationEnableHapticFeedbackProvider),
        () {
      ref.watch(HealpenController().currentPageIndexProvider.notifier).state =
          value;
    });
  }

  Widget _buildPage(BuildContext context, int index, List<Animate> pages) {
    // Moved this logic to a separate function
    return AnimatedOpacity(
      duration: slightlyLongEmphasizedDuration,
      curve: emphasizedCurve,
      opacity: ref.watch(HealpenController().currentPageIndexProvider) == index
          ? 1
          : 0,
      child: pages.elementAt(index),
    );
  }

  bool _havePreferencesChanged(List<PreferenceModel> newPreferences) {
    if (newPreferences.length != _lastFetchedPreferences.length) {
      return true;
    }

    for (int i = 0; i < newPreferences.length; i++) {
      if (newPreferences[i].key != _lastFetchedPreferences[i].key ||
          newPreferences[i].value != _lastFetchedPreferences[i].value) {
        return true;
      }
    }

    return false;
  }
}
