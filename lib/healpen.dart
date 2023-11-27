import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import 'controllers/healpen/healpen_controller.dart';
import 'controllers/settings/firestore_preferences_controller.dart';
import 'controllers/settings/preferences_controller.dart';
import 'controllers/writing_controller.dart';
import 'models/settings/preference_model.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
import 'views/blueprint/blueprint_view.dart';
import 'widgets/healpen_navigation_bar.dart';

List<PreferenceModel> _lastFetchedPreferences = [];

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healpenPageController =
        ref.watch(HealpenController().pageControllerProvider);
    final pages = HealpenController().pages;
    return StreamBuilder(
      stream: FirestorePreferencesController().getPreferences(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PreferenceModel> currentPreferences = snapshot.data!;

          if (_havePreferencesChanged(currentPreferences)) {
            _updatePreferences(ref, currentPreferences);
            _lastFetchedPreferences = currentPreferences;
          }
        }

        return KeyboardDetection(
          controller: KeyboardDetectionController(
            onChanged: (KeyboardState keyboardState) => ref
                .read(WritingController().isKeyboardOpenProvider.notifier)
                .state = [
              KeyboardState.visibling,
              KeyboardState.visible,
            ].contains(keyboardState),
          ),
          child: BlueprintView(
            padBodyHorizontally: false,
            body: PageView.builder(
              itemCount: pages.length,
              controller: healpenPageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int value) {
                _handlePageChange(ref, value);
              },
              itemBuilder: (context, index) {
                final model = HealpenController().models.elementAt(index);
                log(model.label, name: 'Healpen:PageView.builder:itemBuilder');

                // Assign a UniqueKey to each page
                return KeyedSubtree(
                  key: UniqueKey(),
                  child: pages.elementAt(index),
                );
              },
            ),
            bottomNavigationBar: const HealpenNavigationBar(),
          ),
        );
      },
    );
  }

  void _updatePreferences(
    WidgetRef ref,
    List<PreferenceModel> fetchedPreferences,
  ) {
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
        }
      }
    });
  }

  void _handlePageChange(WidgetRef ref, int value) {
    // Moved this logic to a separate function
    vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
      ref.watch(HealpenController().currentPageIndexProvider.notifier).state =
          value;
    });
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
