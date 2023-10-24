import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'controllers/healpen/healpen_controller.dart';
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
  int currentPage = 0;
  double pageOffset = 0;

  @override
  Widget build(BuildContext context) {
    // Moved pages creation to a separate function
    final pages = _buildPages();
    ref.watch(HealpenController().pageControllerProvider).addListener(() {
      setState(() {
        pageOffset =
            ref.watch(HealpenController().pageControllerProvider).page!;
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

        _setupGlobalStyles(context);

        return Scaffold(
          body: PreloadPageView.builder(
            preloadPagesCount: pages.length,
            controller: ref.watch(HealpenController().pageControllerProvider),
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              _handlePageChange(value);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              double scale = 1 - (index - pageOffset).abs();
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..scale(scale, scale),
                alignment: Alignment.center,
                child: PhysicalModel(
                  color: context.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(radius - gap),
                  child: _buildPage(context, index, pages),
                ),
              );
            },
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }

  List<Animate> _buildPages() {
    return [
      for (final page in HealpenController().pages)
        page
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
  }

  void _handlePageChange(int value) {
    // Moved this logic to a separate function
    vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
      ref.watch(HealpenController().currentPageIndexProvider.notifier).state =
          value;
    });
  }

  Widget _buildPage(BuildContext context, int index, List<Animate> pages) {
    // Moved this logic to a separate function
    return AnimatedOpacity(
      duration: emphasizedDuration,
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
