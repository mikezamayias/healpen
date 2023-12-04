import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_detection/keyboard_detection.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'controllers/analysis_view_controller.dart';
import 'controllers/healpen/healpen_controller.dart';
import 'controllers/insights_controller.dart';
import 'controllers/page_controller.dart';
import 'controllers/settings/firestore_preferences_controller.dart';
import 'controllers/settings/preferences_controller.dart';
import 'controllers/writing_controller.dart';
import 'models/analysis/analysis_model.dart';
import 'models/insight_model.dart';
import 'models/settings/preference_model.dart';
import 'providers/settings_providers.dart';
import 'services/firestore_service.dart';
import 'utils/helper_functions.dart';
import 'utils/logger.dart';
import 'views/blueprint/blueprint_view.dart';
import 'widgets/healpen_navigation_bar.dart';

List<PreferenceModel> _lastFetchedPreferences = [];

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healpenPageController =
        ref.watch(HealpenController().preloadPageControllerProvider);
    final pages = HealpenController().pages;

    // Move the logic that updates the state of your providers to didChangeDependencies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateData(ref);
    });
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
        body: PreloadPageView.builder(
          preloadPagesCount: pages.length,
          itemCount: pages.length,
          controller: healpenPageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int value) {
            _handlePageChange(ref, value);
          },
          itemBuilder: (context, index) {
            final model = HealpenController().models.elementAt(index);
            logger.i(
              model.label,
            );
            if ([
              PageController().history.label,
              PageController().insights.label
            ].contains(model.label)) {}
            return pages.elementAt(index);
          },
        ),
        bottomNavigationBar: const HealpenNavigationBar(),
      ),
    );
  }

  void _updateData(WidgetRef ref) {
    FirestorePreferencesController()
        .getPreferences()
        .listen((List<PreferenceModel> snapshot) {
      List<PreferenceModel> currentPreferences = snapshot;
      if (_havePreferencesChanged(currentPreferences)) {
        _updatePreferences(ref, currentPreferences);
        _lastFetchedPreferences = currentPreferences;
      }
    });

    FirestoreService().analysisCollectionReference().snapshots().listen(
      (QuerySnapshot<AnalysisModel> analysisSnapshot) {
        ref
            .read(analysisModelListProvider.notifier)
            .addAll(analysisSnapshot.docs
                .map(
                  (QueryDocumentSnapshot<AnalysisModel> element) =>
                      element.data(),
                )
                .toSet());
      },
    );
  }

  void _updatePreferences(
    WidgetRef ref,
    List<PreferenceModel> fetchedPreferences,
  ) {
    Future.microtask(() {
      Map<String, dynamic> fetchedPreferenceMap = {
        for (PreferenceModel p in fetchedPreferences) p.key: p.value
      };

      for (({
        PreferenceModel preferenceModel,
        StateProvider provider
      }) preferenceTuple in PreferencesController().preferences) {
        String key = preferenceTuple.preferenceModel.key;
        if (fetchedPreferenceMap.containsKey(key)) {
          if (key == PreferencesController.insightOrder.key) {
            List<String> fetchedInsightOrder =
                List.from(fetchedPreferenceMap[key]);
            List<InsightModel> insightModelList =
                ref.read(insightsControllerProvider).insightModelList;
            List<InsightModel> updatedInsightModelList =
                fetchedInsightOrder.map((String title) {
              return insightModelList
                  .firstWhere((element) => element.title == title);
            }).toList();
            ref.read(preferenceTuple.provider.notifier).state.insightModelList =
                updatedInsightModelList;
          } else {
            ref.read(preferenceTuple.provider.notifier).state =
                fetchedPreferenceMap[key];
          }
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
