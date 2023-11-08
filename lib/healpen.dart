import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'controllers/healpen/healpen_controller.dart';
import 'controllers/settings/firestore_preferences_controller.dart';
import 'controllers/settings/preferences_controller.dart';
import 'models/settings/preference_model.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
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
    // Moved pages creation to a separate function
    final healpenPreloadPageController =
        ref.watch(HealpenController().preloadPageControllerProvider);
    final pages = HealpenController().pages;
    ref
        .watch(HealpenController().preloadPageControllerProvider)
        .addListener(() {
      setState(() {
        pageOffset = healpenPreloadPageController.page!;
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

        return Scaffold(
          backgroundColor:
              ref.watch(navigationSmallerNavigationElementsProvider)
                  ? context.theme.colorScheme.surfaceVariant
                  : context.theme.colorScheme.surface,
          body: PreloadPageView.builder(
            preloadPagesCount: pages.length,
            controller: healpenPreloadPageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              _handlePageChange(value);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) => pages.elementAt(index),
          ),
          bottomNavigationBar: const HealpenNavigationBar(),
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
