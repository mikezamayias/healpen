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

class Healpen extends ConsumerStatefulWidget {
  const Healpen({super.key});

  @override
  ConsumerState<Healpen> createState() => _HealpenState();
}

class _HealpenState extends ConsumerState<Healpen> {
  List<PreferenceModel> _lastFetchedPreferences = [];
  int currentPage = 0;
  double pageOffset = 0;

  @override
  Widget build(BuildContext context) {
    final healpenPageController =
        ref.watch(HealpenController().pageControllerProvider);
    final pages = HealpenController().pages;
    healpenPageController.addListener(() {
      setState(() {
        pageOffset = healpenPageController.page!;
      });
    });
    return StreamBuilder(
      stream: FirestorePreferencesController().getPreferences(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PreferenceModel> currentPreferences =
              snapshot.data as List<PreferenceModel>;

          if (_havePreferencesChanged(currentPreferences)) {
            _updatePreferences(currentPreferences);
            _lastFetchedPreferences = currentPreferences;
          }
        }

        return KeyboardDetection(
          controller: KeyboardDetectionController(
            onChanged: (KeyboardState keyboardState) {
              ref
                  .read(WritingController().isKeyboardOpenProvider.notifier)
                  .state = [
                KeyboardState.visibling,
                KeyboardState.visible,
              ].contains(keyboardState);
            },
          ),
          child: BlueprintView(
            padBodyHorizontally: false,
            body: PageView.builder(
              itemCount: pages.length,
              controller: healpenPageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                _handlePageChange(value);
              },
              itemBuilder: (context, index) => pages.elementAt(index),
            ),
            bottomNavigationBar: const HealpenNavigationBar(),
          ),
        );
      },
    );
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
        }
      }
    });
  }

  void _handlePageChange(int value) {
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
