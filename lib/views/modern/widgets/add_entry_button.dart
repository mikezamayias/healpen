import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/color_extensions.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/logger.dart';
import '../../insights/widgets/insights/emotional_echo/widgets/inactive_tile.dart';

class AddEntryButton extends ConsumerStatefulWidget {
  const AddEntryButton({
    super.key,
  });

  @override
  ConsumerState<AddEntryButton> createState() => _AddEntryButtonState();
}

class _AddEntryButtonState extends ConsumerState<AddEntryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => logger.i('Add entry tapped'),
      child: SizedBox(
        width: context.theme.textTheme.headlineLarge!.fontSize! * 3,
        height: context.theme.textTheme.headlineLarge!.fontSize! * 3,
        child: Material(
          type: MaterialType.circle,
          color: onBackgroundColor.applySurfaceTint(
            surfaceTintColor: backgroundColor,
            elevation: radius * 2,
          ),
          child: Center(
            child: EmotionalEchoInactiveTile(
              child: FaIcon(
                FontAwesomeIcons.pen,
                size: context.theme.textTheme.headlineLarge!.fontSize!,
                shadows: [
                  Shadow(
                    color: onBackgroundColor,
                    blurRadius:
                        context.theme.textTheme.headlineLarge!.fontSize!,
                  ),
                ],
                color: onBackgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get averageScore =>
      ref.read(analysisModelSetProvider.notifier).averageScore;

  Color get shapeColor => getShapeColorOnSentiment(context.theme, averageScore);

  Color get textColor => getTextColorOnSentiment(context.theme, averageScore);

  Color get backgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? shapeColor : textColor;

  Color get onBackgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? textColor : shapeColor;
}
