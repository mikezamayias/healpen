import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/insight_controller.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class ReorderInsightsTile extends ConsumerWidget {
  const ReorderInsightsTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsController = ref.watch(insightControllerProvider);
    return CustomListTile(
      titleString: 'Reorder Insights',
      explanationString: 'Long press and drag to reorder insights',
      enableSubtitleWrapper: false,
      subtitle: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            key: ValueKey(index),
            padding: index == insightsController.insightModels.length - 1
                ? EdgeInsets.zero
                : EdgeInsets.only(bottom: gap),
            child: CustomListTile(
              cornerRadius: radius - gap,
              onTap: () {},
              titleString:
                  insightsController.insightModels.elementAt(index).title,
              explanationString:
                  insightsController.insightModels.elementAt(index).explanation,
              trailingIconData: FontAwesomeIcons.gripLines,
            ),
          );
        },
        itemCount: insightsController.insightModels.length,
        onReorder: insightsController.reorderInsights,
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
