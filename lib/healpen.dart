import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide PageController;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

import 'controllers/analysis_view_controller.dart';
import 'controllers/healpen/healpen_controller.dart';
import 'controllers/insights_controller.dart';
import 'controllers/settings/firestore_preferences_controller.dart';
import 'controllers/settings/preferences_controller.dart';
import 'controllers/vibrate_controller.dart';
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

class Healpen extends ConsumerStatefulWidget {
  const Healpen({super.key});

  @override
  ConsumerState<Healpen> createState() => _HealpenState();
}

class _HealpenState extends ConsumerState<Healpen> {
  @override
  Widget build(BuildContext context) {
    final healpenPageController =
        ref.watch(HealpenController().pageControllerProvider);
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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUIOverlayStyle(
          context.theme,
          ref.watch(themeAppearanceProvider),
        ),
        child: GestureDetector(
          onTap: () => context.focusScope.unfocus(),
          child: BlueprintView(
            padBodyHorizontally: false,
            body: PageView.builder(
              itemCount: pages.length,
              controller: healpenPageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int value) {
                _handlePageChange(ref, value);
              },
              itemBuilder: (BuildContext context, int index) =>
                  pages.elementAt(index),
            ),
            bottomNavigationBar: const HealpenNavigationBar(),
          ),
        ),
      ),
    );
  }

  void _updateData(WidgetRef ref) {
    FirestorePreferencesController()
        .getPreferences()
        .listen((List<PreferenceModel> snapshot) async {
      List<PreferenceModel> currentPreferences = snapshot;
      if (_havePreferencesChanged(currentPreferences)) {
        await _updatePreferences(ref, currentPreferences);
        _lastFetchedPreferences = currentPreferences;
      }
    });

    FirestoreService().analysisCollectionReference().snapshots().listen(
      (QuerySnapshot<AnalysisModel> analysisSnapshot) {
        ref.read(analysisModelSetProvider.notifier).addAll(analysisSnapshot.docs
            .map(
              (QueryDocumentSnapshot<AnalysisModel> element) => element.data(),
            )
            .toSet());
      },
    );
  }

  Future<void> _updatePreferences(
    WidgetRef ref,
    List<PreferenceModel> fetchedPreferences,
  ) async {
    await Future.microtask(
      () {
        Map<String, dynamic> fetchedPreferenceMap = {
          for (PreferenceModel p in fetchedPreferences) p.key: p.value
        };

        for (({
          PreferenceModel preferenceModel,
          StateProvider provider,
          bool log,
        }) preferenceTuple in PreferencesController().preferences) {
          if (preferenceTuple.log) {
            logger.i(
              'Updating ${preferenceTuple.preferenceModel.key} to ${fetchedPreferenceMap[preferenceTuple.preferenceModel.key]}',
            );
            logger.i('Current value: ${ref.watch(preferenceTuple.provider)}');
          }
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
              ref
                  .read(preferenceTuple.provider.notifier)
                  .state
                  .insightModelList = updatedInsightModelList;
            } else {
              ref.read(preferenceTuple.provider.notifier).state =
                  fetchedPreferenceMap[key];
            }
          }
        }
      },
    );
  }

  void _handlePageChange(WidgetRef ref, int value) {
    // Moved this logic to a separate function
    VibrateController().run(() {
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
