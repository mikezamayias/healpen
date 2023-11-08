import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/insights_controller.dart';
import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../models/insight_model.dart';
import '../../../../models/settings/preference_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ReorderInsightsTile extends ConsumerWidget {
  const ReorderInsightsTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsController = ref.watch(insightsControllerProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Reorder Insights',
      explanationString: 'Long press and drag to reorder insights.',
      enableSubtitleWrapper: false,
      subtitle: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            key: ValueKey(
              insightsController.insightModelList.elementAt(index).title,
            ),
            padding: index == insightsController.insightModelList.length - 1
                ? EdgeInsets.zero
                : EdgeInsets.only(bottom: gap),
            child: CustomListTile(
              useSmallerNavigationSetting:
                  !ref.watch(navigationSmallerNavigationElementsProvider),
              enableExplanationWrapper: false,
              cornerRadius: radius - gap,
              onTap: () {},
              titleString:
                  insightsController.insightModelList.elementAt(index).title,
              explanationString: insightsController.insightModelList
                  .elementAt(index)
                  .explanation,
              trailingIconData: FontAwesomeIcons.gripLines,
            ),
          );
        },
        itemCount: insightsController.insightModelList.length,
        onReorder: (int oldIndex, int newIndex) async {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
            insightsController.reorderInsights(oldIndex, newIndex);
          });
          var preferenceModel = PreferenceModel<List<String>>(
            'insightOrder',
            insightsController.insightModelList
                .map((InsightModel e) => e.title)
                .toList(),
          );
          log(preferenceModel.toString(), name: 'ReorderInsightsTile');
          await FirestorePreferencesController()
              .savePreference(preferenceModel);
        },
        proxyDecorator: (child, index, animation) {
          return Material(
            color: Colors.transparent,
            child: child,
          );
        },
      ),
    );
  }
}
