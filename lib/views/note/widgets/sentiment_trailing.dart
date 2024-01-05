import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:sprung/sprung.dart';

import '../../../controllers/vibrate_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../note_view.dart';

class SentimentTrailing extends ConsumerWidget {
  const SentimentTrailing({
    super.key,
    required this.score,
  });

  final double score;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleGestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalSwipe: (direction) {
        VibrateController().run(
          () {
            if (direction == SwipeDirection.up) {
              ref.read(showEmojiInTrailingProvider.notifier).state = false;
            } else if (direction == SwipeDirection.down) {
              ref.read(showEmojiInTrailingProvider.notifier).state = true;
            }
          },
        );
      },
      child: AnimatedCrossFade(
        duration: standardDuration,
        reverseDuration: standardDuration,
        sizeCurve: Sprung.criticallyDamped,
        firstCurve: Sprung.criticallyDamped,
        secondCurve: Sprung.criticallyDamped,
        crossFadeState: ref.watch(showEmojiInTrailingProvider)
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: FaIcon(
          getSentimentIcon(score),
          color: getShapeColorOnSentiment(
            context.theme,
            score,
          ),
          size: context.theme.textTheme.displaySmall!.fontSize,
        ),
        secondChild: Text(
          score.toStringAsFixed(1),
          style: context.theme.textTheme.headlineLarge?.copyWith(
            fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
            fontWeight: FontWeight.bold,
            color: getShapeColorOnSentiment(
              context.theme,
              score,
            ),
          ),
        ),
      ),
    );
  }
}
