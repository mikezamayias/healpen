import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../extensions/int_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class EntryTile extends StatefulWidget {
  const EntryTile({
    super.key,
    required this.analysisModel,
  });

  final AnalysisModel analysisModel;

  @override
  State<EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends State<EntryTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: Text(
        analysisModel.timestamp.timestampToEEEEMMMd(),
        style: context.theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: onBackgroundColor,
        ),
      ),
      title: const SizedBox.shrink(),
      trailing: Text(
        analysisModel.timestamp.timestampToHHMM(),
        style: context.theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: onBackgroundColor,
        ),
      ),
      shadowColor: onBackgroundColor,
      backgroundColor: backgroundColor,
      elevation: gap,
      subtitle: Padding(
        padding: EdgeInsets.all(gap),
        child: Text(
          widget.analysisModel.content,
          style: context.theme.textTheme.titleMedium,
        ),
      ),
    );
  }

  AnalysisModel get analysisModel => widget.analysisModel;

  Color get shapeColor => getShapeColorOnSentiment(
        context.theme,
        analysisModel.score,
      );

  Color get textColor => getTextColorOnSentiment(
        context.theme,
        analysisModel.score,
      );

  Color get backgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? shapeColor : textColor;

  Color get onBackgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? textColor : shapeColor;
}
