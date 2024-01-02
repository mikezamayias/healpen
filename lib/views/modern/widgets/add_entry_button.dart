import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/logger.dart';
import '../../insights/widgets/insights/emotional_echo/widgets/inactive_tile.dart';

class AddEntryButton extends ConsumerWidget {
  const AddEntryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColorOnSentiment = getTextColorOnSentiment(
      context.theme,
      ref.read(analysisModelSetProvider.notifier).averageScore,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => logger.i('Add entry tapped'),
      child: SizedBox(
        width: context.theme.textTheme.headlineLarge!.fontSize! * 3,
        height: context.theme.textTheme.headlineLarge!.fontSize! * 3,
        child: EmotionalEchoInactiveTile(
          child: FaIcon(
            FontAwesomeIcons.pen,
            size: context.theme.textTheme.headlineLarge!.fontSize!,
            shadows: [
              Shadow(
                color: textColorOnSentiment,
                blurRadius: context.theme.textTheme.headlineLarge!.fontSize!,
              ),
            ],
            color: textColorOnSentiment,
          ),
        ),
      ),
    );
  }
}
