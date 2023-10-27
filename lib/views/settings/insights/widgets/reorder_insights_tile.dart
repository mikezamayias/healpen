import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/insights_controller.dart';
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
      titleString: 'Reorder Insights',
      explanationString: 'Long press and drag to reorder insights',
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
        onReorder: (oldIndex, newIndex) {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
            insightsController.reorderInsights(oldIndex, newIndex);
            insightsController.pageController.jumpToPage(newIndex);
          });
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
