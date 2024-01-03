import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/analysis_model_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class ModernAppBarAction extends ConsumerStatefulWidget {
  final void Function() onTap;
  final IconData iconData;

  const ModernAppBarAction({
    super.key,
    required this.onTap,
    required this.iconData,
  });

  @override
  ConsumerState<ModernAppBarAction> createState() => _ModernAppBarActionState();
}

class _ModernAppBarActionState extends ConsumerState<ModernAppBarAction> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      responsiveWidth: true,
      onTap: onTap,
      leadingIconData: iconData,
      backgroundColor: onBackgroundColor,
      textColor: backgroundColor,
    );
  }

  IconData get iconData => widget.iconData;

  void Function() get onTap => widget.onTap;

  Set<AnalysisModel> get analysisModelSet =>
      ref.watch(analysisModelSetProvider);

  Color get shapeColor => getShapeColorOnSentiment(
        context.theme,
        analysisModelSet.averageScore(),
      );

  Color get textColor => getTextColorOnSentiment(
        context.theme,
        analysisModelSet.averageScore(),
      );

  Color get backgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? shapeColor : textColor;

  Color get onBackgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? textColor : shapeColor;
}
